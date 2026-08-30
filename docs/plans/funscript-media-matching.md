# Fuzzy Funscript/Media Matching

## Status

Implemented and in the app, reachable from the media library toolbar.

## Objective

Give Syncopathy a manually launched repair flow that proposes video matches for
funscripts the existing longest-prefix trie cannot resolve, and lets a person
work through them quickly and safely.

The core deliverable is a **deterministic fuzzy matcher**: given a funscript that
did not match, it produces a small ranked list of plausible videos, each carrying
the evidence that put it there. That list is the product. It is fully testable,
it runs offline, and it is what makes the rest safe.

A **review workspace** turns that list into decisions. Nothing is written until
an explicit Apply, and what Apply wrote can be undone in one action.

## Non-goals

- Do not replace or weaken the existing trie matcher.
- Do not rank the full library; only videos nothing is already linked to.
- Do not automatically accept anything the matcher has flagged.
- Do not rename, move, copy, or delete files.
- Do not send anything anywhere. The tool is entirely local.
- Do not run during indexing, startup, browsing, playback or automatic relinking.

## Existing Behavior

The current indexer:

1. Builds a trie from media basenames.
2. Matches each funscript to the longest media-basename prefix.
3. Skips a newly found funscript when it is neither already known nor matched by the trie.
4. Prunes new media groups that have no linked funscript.
5. Imports and links only the resulting deterministic groups.

That stays the primary matching behavior. This flow independently rediscovers the
files the indexer intentionally discarded, runs the same trie check, and keeps
only the failures.

## Architecture

```text
        Media library toolbar -> Match funscripts
                     |
                     v
        Read-only filesystem discovery (isolate)
                     |
                     v
        Existing trie check --------------> resolved cases excluded
                     |
                     v
        Fuzzy candidate ranking   <-- the feature
                     |
              MatchProposal list
              (bounded, explained, flagged)
                     |
                     v
        Review workspace (no writes)
                     |
                     v
        Explicit Apply -> revalidate -> one transaction
                     |
                     v
        Undo, or deterministic relations for future scans
```

Nothing in this pipeline is registered as a startup effect or reachable from
`MediaManager.startIndexing()`.

## Discovery and Residual Selection

Discovery produces lightweight snapshots:

- Video: hash, basename, sanitized parent-folder label, duration, dimensions, type.
- Funscript: hash, basename, sanitized parent-folder label, metadata title,
  performers, metadata duration, final action timestamp, axis suffix.

After discovery:

- Build the same media-basename trie used by normal indexing.
- Drop every funscript that `findLongestPrefix` resolves, and say how many, so a
  script that a plain library refresh would handle is never fuzzily guessed at.
- Drop already-linked funscripts.
- Rank only against videos nothing is linked to. A video that already has a
  script is not what a stranded script is missing, and excluding it makes the
  candidate pool both smaller and likelier to hold the right answer.
- Bundle multi-axis companions by shared stem so a secondary axis cannot be
  matched to a different video than its stroke script.

Paths are kept on the session rather than on the snapshots, which stay a
description of a file rather than a handle to one.

## The Fuzzy Matcher

Pure, synchronous, dependency-free Dart over snapshots — no I/O, no database — so
it can be exhaustively unit tested and evaluated against a fixture.

Normalization:

- Unicode-aware lowercasing; separator and punctuation folding; camelCase splitting.
- Strip container extension and known multi-axis suffixes.
- Strip release noise: resolution, codec, source, VR projection, framerate,
  release-group and site suffixes.
- Tokenize, keeping numeric and alphanumeric identifiers intact.
- Extract season/episode/scene/part numbers out of the token stream.

Scored features, each retained on the candidate as evidence:

- Token overlap, **weighted by how rare each shared word is in this library**.
- Edit distance / n-gram similarity on the normalized stem.
- Shared numeric identifiers, scene/episode numbers, dates, studio tokens.
- Folder proximity, as a label rather than a path.
- Script metadata title and performer overlap, when present.
- Duration compatibility, asymmetric: a script is expected to end early.

Penalties (multiplicative):

- Conflicting episode/scene numbers.
- Large duration mismatch.

Cautions (advisory, never scored):

- The shared words are all words much of the library uses.
- The filenames share nothing; only script metadata brought the pair together.
- Nothing outside the names could be compared.

Output per funscript: a bounded top-K (configurable, default 12) or an explicit
`no candidates`. Each entry carries its score, its per-feature contributions, the
words the two names share, and which of those are actually distinctive.

## Guarding Against Confident Wrong Answers

A strong false positive — a high score on a pair that is simply wrong — is the
failure mode that matters, because it is the one a reviewer is most likely to
wave through. Three things address it:

1. **Rarity weighting.** Shared words count in proportion to how rare they are.
   Two files agreeing on a studio name, a year and the word "scene" no longer
   outscore the one file that agrees on the actual title. The weight is floored,
   so a common word still counts for something, and frequency is only consulted
   once the pool is big enough for it to mean anything.
2. **Cautions.** Where the matcher cannot distinguish a good match from a
   plausible-looking one, it says so instead of implying certainty.
3. **The runner-up gap.** A 70% top candidate with a 68% runner-up is a coin toss
   wearing a confident number. The review UI leads with that, not with the score.

Bulk acceptance takes only candidates that are strong, clearly ahead of the
runner-up, and unflagged.

## The Review Workspace

Per unresolved funscript:

- The funscript, labelled as one, with its full path — copyable, and openable in
  the file manager.
- Ranked videos, each labelled as one, with the same.
- Words the two names share highlighted in both, distinctive ones picked out, so
  the score can be checked rather than trusted.
- Score, contributing features, penalties and cautions.
- A one-line judgement: either "this looks clear, and here is the margin" or
  "worth checking, and here is why".
- Multi-axis companions that will follow the decision.

Actions: accept the top suggestion, pick another, mark no match, skip, accept all
the unambiguous ones, Apply, undo the last Apply.

The list is filtered (needs review / decided / no suggestion / all), searchable
across both funscript and video names, and fully keyboard-driven: arrows to move,
Enter to take the top suggestion, 1–9 to pick a specific video, N for no match,
S to skip, U to undo a row. Deciding advances to the next row that needs one.

No per-row action writes anything.

## Applying Accepted Matches

Before writing:

- Revalidate that both files still exist and still hash the same.
- Recheck nothing else changed since discovery.
- Confirm secondary-axis bundles attach alongside a stroke script without a
  secondary axis becoming the main script.

Apply all accepted decisions in one ObjectBox write transaction:

- Reuse existing `MediaFile`/`FunscriptFile` entities by hash when present.
- Create missing entities using the same analysis and metadata rules as indexing,
  running ffprobe for videos being imported for the first time.
- Add the funscript relation without removing other valid scripts.
- Select the main funscript through `pickMainFunscript` only when the slot is empty.
- Record the accepted script basename as a media alias.
- Preserve rejected pairs so they are not suggested again.

Record what each link cost, so the batch can be undone: which relation was
created, whether this Apply filled the main-script slot, which alias it added,
and which rows it brought into existence. Undoing removes exactly that and
nothing else — a video that already had other scripts keeps them, a main-script
slot that was empty before goes back to empty, and a row this tool imported
disappears again. Files on disk are never touched.

## Persistence

Rejections only, as opaque hash pairs:

- Script hash, video hash, in one key.
- Capped, oldest dropped first.
- Excluded during candidate generation on later runs.
- Clearable from the tool's own settings.

Accepted matches need no persisted rule. Indexing only ever *adds* to a media's
script relation, so a link written here survives every later scan on its own.

## Settings

Under the tool itself, not the general settings page:

- Maximum candidates per script.
- Minimum score to show a candidate.
- Include folder labels / include funscript metadata toggles.
- Move on after each decision.
- Forget rejections.

## Failure Behavior

- No plausible candidate: report `no candidates`, in its own filter.
- Files changed before Apply: invalidate the affected decision and say which.
- Apply transaction failure: roll back all selections and report the error.
- Unreadable folders: reported, and the rest of the scan continues.
- A funscript that will not parse: skipped, logged, and the pass continues.

## Test Matrix

- Reordered words, punctuation changes, abbreviations, missing tokens.
- Resolution, codec, release-group, VR projection and website suffix noise.
- Scene/episode numbers where a one-digit difference must block a match.
- Same title with different performers, studios, years or parts.
- Close names with materially different durations.
- Metadata-present and metadata-absent funscripts.
- Plain stroke, explicit `L0`/`stroke`, and secondary-axis companions.
- Duplicate media hashes under different aliases.
- No valid match, and multiple genuinely ambiguous matches.
- A library that names everything the same way.
- A script whose true video is not present at all.
- Files deleted or changed between discovery and Apply.

## Acceptance Criteria

- The normal indexer is unchanged.
- The tool is launched explicitly and considers only trie-unresolved funscripts.
- Candidates come only from videos nothing is linked to.
- No database or filesystem mutation before explicit Apply.
- An accept can never name a video that was not offered.
- Accepted matches become deterministic persisted relations.
- Rejected candidates are not repeatedly suggested.
- Multi-axis companions cannot make a secondary axis the main stroke script.
- Everything one Apply wrote can be undone in one action.

## Risks and Open Questions

- Rarity weighting is only as good as the pool it measures; a library whose
  filenames are all near-identical will still produce ties, which is why the
  runner-up gap is surfaced rather than hidden.
- Duration can disagree legitimately: scripts may be partial, shifted, or
  authored for a different cut.
- Accepted-rule precedence is unspecified against later manual relinking.
- The evaluation fixture is synthetic. Real libraries will find shapes it does
  not contain.

## Progress

Complete, less the evaluation reporting in the last section below.

### What runs

```text
Media library toolbar -> Match funscripts
        |
        v
MatchDiscovery (isolate, read-only)
  walks the search paths, hashes both sides, and keeps
  only funscripts nothing links and videos nothing links
        |
        v
FuzzyMatcher, over unmatched videos only,
  weighting shared words by rarity and flagging what it cannot tell apart
        |
        v
MatchDraft: proposals + decisions, in memory, no writes
        |
        v
Review workspace: filter, search, keyboard, bulk-accept the unambiguous
        |
        v
Apply -> revalidate -> one write transaction -> undoable
```

| File | What it is |
|---|---|
| `name_normalizer.dart` | Filename reduction: camelCase splitting, diacritic folding, separator folding, release-noise removal, identifier and ordinal extraction, trigrams. |
| `match_snapshot.dart` | `MediaSnapshot` / `FunscriptSnapshot` — hash, basename, folder label, duration. No entity, no `File`, no absolute path. |
| `match_features.dart` | `MatchFeature`, `MatchPenalty`, `MatchCaution`, `ScoredCandidate`, `MatchProposal`. |
| `fuzzy_matcher.dart` | Inverted-index gate, rarity-weighted two-stage scoring, top-K ranking, cautions, multi-axis bundling. |
| `match_draft.dart` | `MatchDecision`, `MatchDraft` (validation and the no-writes draft), `AcceptedMatch`. |
| `match_discovery.dart` | The read-only filesystem pass, in an isolate. Produces `UnmatchedMedia` / `UnmatchedFunscript`. |
| `match_apply.dart` | Revalidation, the single write transaction, and its undo. |
| `match_rules_store.dart` | Persisted rejected pairs, so a turned-down pair is never offered twice. |
| `matching_settings.dart` | The tool's own settings, persisted through `KVStore`. |
| `matching_session_model.dart` | One session: scan, re-rank, filter, decide, apply, undo, retire what was applied. |
| `funscript_matching_page.dart` | The review workspace. |
| `matching_settings_dialog.dart` | The matcher knobs, inside the tool. |

`media_file_scanner.dart` (outside `matching/`) is the directory walk, extracted
from `MediaManager` so indexing and this tool cannot disagree about what counts
as media.

### Deviations from the plan as written

**Candidates come only from videos nothing is linked to.** An earlier draft
ranked against the whole library. Narrowing it is both faster and more accurate:
a video that already has a script is almost never what a stranded script belongs
to, and every one of them left in the pool is another chance to outscore the
right answer.

**Video duration is used when the library already knows it, and never fetched.**
Scoring runs on names and folder labels. Probing every unmatched video with
ffprobe would cost more than the rest of the pass put together and buy a feature
worth 0.08 of the weight; ffprobe runs at Apply instead, for the handful of
videos being imported for the first time.

**Scoring is a weighted mean over the features that apply**, not a fixed sum.
A pair with no durations, no folder labels and no script metadata is scored on
name evidence alone rather than being marked down for signals it could not have
had. Penalties then multiply the result, so a contradicting scene number demotes
a textually perfect match instead of nudging it.

**Shared words are weighted by rarity, with a floor.** A word every candidate
carries is weak evidence, not *no* evidence, and in a small pool every word looks
ubiquitous — an unfloored weight scores a two-file library at zero, which is the
opposite of what rarity weighting is for. Frequency is only consulted at all once
the pool has at least eight entries.

**Cautions are advisory and tiered.** Two of them say the name evidence itself is
weak and hold a candidate back from bulk acceptance. The third only says nothing
outside the names could be checked, which is true of most filename matching;
treating that as suspicious would make an unreviewed accept impossible rather
than careful.

**The identifier feature only applies when both names carry an identifier.**
A script stripped to a bare title has no code to disagree with, and treating its
absence as a mismatch buried every correct match of that shape.

**Ordinal agreement earns nothing; disagreement is near-fatal.** Two names
agreeing on `scene 1` is common and says almost nothing, while `scene 3` versus
`scene 4` is the exact case fuzzy text matching gets wrong. With the default
score floor the conflicting candidate does not merely rank lower — it drops out
of the suggestions entirely.

**Duration is asymmetric.** A script whose only duration signal is its last
action timestamp is expected to end before the video does, so the shortfall
tolerance widens rather than counting against it.

**Validation lives in `MatchDraft.record`.** An accept naming a candidate the
proposal does not contain is stored as an error, never as a match. Everything
that reaches Apply comes through there.

**An accepted match needs no alias rule to survive a rescan.** An earlier draft
wanted a persisted rule so later scans resolve deterministically. It turned out
to be unnecessary: indexing only ever *adds* to a video's script relation, so a
link written here survives every later scan on its own. Rejections still persist,
because nothing else remembers them.

**Paths live on the session, not on the snapshots.** The UI needs full paths and
the ability to open a folder; keeping the lookup on the session means the
snapshot stays a description of a file rather than a handle to one.

**Rows with no candidates are not in the review queue.** They are undecided, but
there is nothing to decide — leaving them in would make the queue look
permanently unfinished. They have their own filter.

### Measured on the evaluation fixture

15 residual pairs (each asserted to be one the trie genuinely fails on) against a
library that also holds five non-overlapping distractors:

- Top-1 accuracy: 15/15.
- The gap between the weakest true match and the strongest false one is asserted
  as `_separationThreshold = 0.40` in `test/matching/fuzzy_matcher_test.dart`. It
  is a measurement, not a rule the matcher enforces; it moving is the signal that
  scoring has changed shape.
- A script sharing nothing with the library produces no candidates.

### Known limits

- Two names sharing no word and no identifier are never compared. Heavy
  abbreviation (`MSc` for `My Scene`) is therefore a miss, by design: the gate is
  what keeps a pass linear in the library size.
- Noise vocabulary and diacritic folding are curated lists covering the shapes
  these filenames actually use, not exhaustive Unicode handling.
- The filesystem pass cannot be cancelled part-way; it runs to completion.
- Changing a scoring option re-ranks, which rebuilds the draft and therefore
  clears decisions made against the ranking that no longer exists.
- Undo covers the most recent Apply only, and a rescan retires it.
- No local evaluation reporting yet, and no collection of user-confirmed false
  positives to grow the fixture with.

### Dropped

An optional Ollama agent decider was built and then removed, along with its
approval queue, its per-proposal discussion panel and the `MatchDecider` seam
that existed to hold both it and the human path. The matcher was always the
feature; the model was one way to drive it, and it did not earn the surface area.
The parts of that work that were about *the human* reviewing safely — validation
in one place, the undo of an Apply, and treating a confident score as something
to be checked rather than trusted — are kept.
