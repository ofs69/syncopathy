#include <locale.h>
#include "my_application.h"

int main(int argc, char** argv) {
  setlocale(LC_NUMERIC, "C");
  g_autoptr(MyApplication) app = my_application_new();
  return g_application_run(G_APPLICATION(app), argc, argv);
}
