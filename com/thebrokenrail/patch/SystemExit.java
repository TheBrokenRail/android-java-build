package com.thebrokenrail.patch;

public class SystemExit extends RuntimeException {
  public static void exit(int signal) {
    throw new SystemExit(String.valueOf(signal));
  }
}
