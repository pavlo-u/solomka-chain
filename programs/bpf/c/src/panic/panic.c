/**
 * @brief Example C-based BPF program that prints out the parameters
 * passed to it
 */
#include <solomka_sdk.h>

extern uint64_t entrypoint(const uint8_t *input) {
  sol_panic();
  return SUCCESS;
}
