.386
.MODEL FLAT
.DATA
		a REAL4 0.0		
		b REAL4 2.0		
		x REAL4 0.5
		eps REAL4 ?	;precision
		resultAdress REAL4 ?	

.CODE
_HordMethod PROC 
		; region ARG
		PUSH EBP 
		MOV EBP, ESP
		MOV EAX,[EBP]+8
		MOV eps ,EAX 
		MOV EAX,[EBP]+12
		MOV resultAdress, EAX 
		XOR EDX, EDX 
		XOR EBX, EBX 
		; end region ARG

		FINIT
		FLD a		; start approximation value
		.WHILE DL == 0
				CALL CalculateIntersection	; calculate current point of crossing
				FXCH ST(1)		
				FSUB ST, ST(1)	
				FABS	
				
				FLD eps			
				FCOMPP ; check endpoint inequality x(i) - x(i - 1) > eps
				FSTSW AX	
				SAHF
				JC ITERATION
						INC EDX ; DL == 1
						JMP CLOSE 

				ITERATION:
				; region ITERATION - when f(x(i))*f(a)>0 == b(k) = x(k), else a(k)=x(k)
				FLD ST		
				CALL MakeFunction		
				FLD a		
				CALL MakeFunction		
				FMULP		

				FTST		
				FSTSW AX
				SAHF
				FSTP ST		
				JC ac		
						FST a
						JMP EXIT
				ac:
						FST b
						JMP EXIT
				EXIT:
				INC EBX 
				; end region ITERATION

				CLOSE:
		.ENDW

		MOV ECX , resultAdress
		FSTP x
		MOV EDX, x
		MOV [ECX] , EDX
		MOV EAX, EBX
		POP EBP 
		RET
_HordMethod ENDP


CalculateIntersection PROC
		FLD a			
		CALL MakeFunction		
		FLD b			
		CALL MakeFunction		
		FSUB ST, ST(1)	
		FLD b			
		FLD a			
		FSUBP			
		FMULP ST(2), ST	
		FDIVP			
		FLD a			
		FSUBRP			
		RET
CalculateIntersection ENDP

MakeFunction PROC
		; region Func - return into ST(0) current value of function
		FLD x			
		FADD ST, ST(1)	
		FLD1			
		FXCH ST(1)		
		FYL2X			
		FLDL2E			
		FDIVP			
		FADDP			
		FLD x			
		FSUBP			
		RET
		; end region Func
MakeFunction ENDP

END