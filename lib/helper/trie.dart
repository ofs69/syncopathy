/// A prefix tree used by media indexing to match funscript filenames to the
/// longest media-filename prefix they share.
class TrieNode {
  Map<String, TrieNode> children = {};
  bool isEndOfWord = false;
  String? fullWord;
}

class Trie {
  final TrieNode root = TrieNode();

  void insert(String word) {
    TrieNode current = root;
    for (int i = 0; i < word.length; i++) {
      current = current.children.putIfAbsent(word[i], () => TrieNode());
    }
    current.isEndOfWord = true;
    current.fullWord = word;
  }

  // Finds the LONGEST prefix that exists in the trie
  String? findLongestPrefix(String word) {
    TrieNode current = root;
    String? longestMatch;

    for (int i = 0; i < word.length; i++) {
      String char = word[i];
      if (current.children.containsKey(char)) {
        current = current.children[char]!;
        // Update every time we hit a valid media file name
        if (current.isEndOfWord) {
          longestMatch = current.fullWord;
        }
      } else {
        // No further path in Trie, return the best match found so far
        break;
      }
    }
    return longestMatch;
  }
}
