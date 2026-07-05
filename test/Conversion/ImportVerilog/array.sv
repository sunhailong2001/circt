// RUN: circt-verilog --ir-moore %s | FileCheck %s
// REQUIRES: slang

// Internal issue in Slang v3 about jump depending on uninitialised value.
// UNSUPPORTED: valgrind

// The assignment pattern '{...} populates arrays and vectors from the leftmost
// bound of the target type. Moore aggregate values use descending storage
// order, so ascending SV ranges must be reversed while descending ranges are
// already in storage order.

// CHECK-LABEL: moore.module @array_assign_packed
// CHECK: moore.array_create %d, %c, %b, %a
module array_assign_packed(input wire [15:0] a, b, c, d,
                           output wire [3:0][15:0] out);
  assign out = '{d, c, b, a};
endmodule

// CHECK-LABEL: moore.module @array_assign_packed_ascending
// CHECK: moore.array_create %a, %b, %c, %d
module array_assign_packed_ascending(input wire [15:0] a, b, c, d,
                                     output wire [0:3][15:0] out);
  assign out = '{d, c, b, a};
endmodule

// Unpacked arrays without explicit bounds are [0:N-1], so out[0] receives d
// and the array_create operands must be reversed into descending storage order.
// CHECK-LABEL: moore.module @array_assign_unpacked_implicit
// CHECK: moore.array_create %a, %b, %c, %d
module array_assign_unpacked_implicit(input wire [15:0] a, b, c, d,
                                      output wire [15:0] out[4]);
  assign out = '{d, c, b, a};
endmodule

// CHECK-LABEL: moore.module @array_assign_unpacked_ascending
// CHECK: moore.array_create %a, %b, %c, %d
module array_assign_unpacked_ascending(input wire [15:0] a, b, c, d,
                                       output wire [15:0] out[0:3]);
  assign out = '{d, c, b, a};
endmodule

// CHECK-LABEL: moore.module @array_assign_unpacked_descending
// CHECK: moore.array_create %d, %c, %b, %a
module array_assign_unpacked_descending(input wire [15:0] a, b, c, d,
                                        output wire [15:0] out[3:0]);
  assign out = '{d, c, b, a};
endmodule

// CHECK-LABEL: moore.module @int_assign_descending
// CHECK-DAG: %[[X0:.*]] = moore.constant 0
// CHECK-DAG: %[[X1:.*]] = moore.constant 1
// CHECK: moore.concat %[[X1]], %[[X0]]
module int_assign_descending(output wire [1:0] out);
  assign out = '{0, 1};
endmodule

// CHECK-LABEL: moore.module @int_assign_ascending
// CHECK-DAG: %[[X0:.*]] = moore.constant 0
// CHECK-DAG: %[[X1:.*]] = moore.constant 1
// CHECK: moore.concat %[[X0]], %[[X1]]
module int_assign_ascending(output wire [0:1] out);
  assign out = '{0, 1};
endmodule
