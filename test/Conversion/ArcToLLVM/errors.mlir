// RUN: circt-opt %s --lower-arc-to-llvm --verify-diagnostics

func.func @constant_time_too_large() -> !llhd.time {
  // expected-error @below {{failed to legalize operation 'llhd.constant_time'}}
  %0 = llhd.constant_time <9224s, 0d, 0e>
  return %0 : !llhd.time
}
