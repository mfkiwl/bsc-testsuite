
typedef UInt#(51) NumTyp;

interface ArithIO_IFC #(type aTyp); // aTyp is a paramerized type
    // if the user specifies dollar signs
    // and then has them taken out, 
    // then we have a problem
    (* prefix="xx$yy" *)
    method Action start(aTyp num1, aTyp num2);
    method aTyp num1();
endinterface: ArithIO_IFC

// The following is an attribute that tells the compiler to generate
// separate code for mkGCD
(* synthesize *)
module mkGCD(ArithIO_IFC#(NumTyp)); // here aTyp is defined to be type Int
    Reg#(NumTyp) x();  // x is the interface to the register
    mkReg#(?) xx_yy_num1(x); // the_x is the register instance

    Reg#(NumTyp) y();
    mkReg#(0) the_y(y);

    rule flip (x > y && y != 0);
        x <= y;
        y <= x;
    endrule

    rule sub (x <= y && y != 0);
        y <= y - x;
    endrule

    method Action start(NumTyp num1, NumTyp num2) if (y == 0);
        action
            x <= num1;
            y <= num2;
        endaction
    endmethod: start

    method NumTyp num1() if (y == 0);
        num1 = x;
    endmethod: num1

endmodule: mkGCD

