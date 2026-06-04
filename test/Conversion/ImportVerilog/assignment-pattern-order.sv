// RUN: circt-translate --import-verilog %s | FileCheck %s
// REQUIRES: slang

// CHECK-LABEL: moore.module @AssignmentPatternOrder
module AssignmentPatternOrder;
  // Positional assignment patterns for packed integers follow the declared
  // range direction.
  // CHECK: [[D_ZERO:%.+]] = moore.constant 0 : l1
  // CHECK: [[D_ONE:%.+]] = moore.constant 1 : l1
  // CHECK: moore.concat [[D_ZERO]], [[D_ONE]] : (!moore.l1, !moore.l1) -> l2
  wire [1:0] desc = '{0, 1};

  // CHECK: [[A_ZERO:%.+]] = moore.constant 0 : l1
  // CHECK: [[A_ONE:%.+]] = moore.constant 1 : l1
  // CHECK: moore.concat [[A_ONE]], [[A_ZERO]] : (!moore.l1, !moore.l1) -> l2
  wire [0:1] asc = '{0, 1};

  bit [31:0] arr [2];
  bit [31:0] out0, out1;

  initial begin
    // CHECK: [[ARR0:%.+]] = moore.constant 67 : i32
    // CHECK: [[ARR1:%.+]] = moore.constant 36866 : i32
    // CHECK: [[ARR:%.+]] = moore.array_create [[ARR0]], [[ARR1]] : !moore.i32, !moore.i32 -> uarray<2 x i32>
    arr = '{32'h43, 32'h9002};

    // CHECK: moore.extract {{%.+}} from 1 : uarray<2 x i32> -> i32
    out0 = arr[0];
    // CHECK: moore.extract {{%.+}} from 0 : uarray<2 x i32> -> i32
    out1 = arr[1];
  end
endmodule
