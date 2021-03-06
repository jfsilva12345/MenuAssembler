
.MODEL SMALL
.STACK 200H
.DATA
    
    MSG0    DB 10,13, ' INGRESE CONTRASENA: ', '$'

    MSGMENU DB 10,13, ' ********************* MENU *********************'
    OPC1    DB 10,13, "1.- SUMA Y DIFERENCIA DE DOS NUMEROS ENTRE 0 Y 255"
    OPC2    DB 10,13, "2.- MULTIPLICACION Y DIVISION DE DOS NUMEROS ENTRE 0 Y 255"
    OPC3    DB 10,13, "3.- FORMA BINARIA Y OPERACIONES LOGICAS A DOS NUMEROS HEX"
    OPC4    DB 10,13, "4.- SERIE FIBONACCI"
    OPC5    DB 10,13, "5.- SALIR $"
    MSGOP   DB 10,13, "DIGITE UNA OPCION ENTRE 1 Y 5:  $"
    MSGESPERARTECLA DB 10,13, "PRESIONE CUALQUIER TECLA PARA CONTINUAR.. $"
 
    MSGNUM1     DB 10, 13, " INGRESE PRIMER NUMERO ", 10, 13, '$'
    MSGNUM2     DB 10, 13, " INGRESE SEGUNDO NUMERO ", 10, 13, '$'
    MSGNUMING   DB 10,13, ' NUMERO INGRESADO: $'
    MSGSUMA     DB 10,13, ' SUMA: $'
    MSGRESTA    DB 10,13, ' RESTA: $'
    MSGRESTANEG DB 10,13, ' RESTA: -$'
    MSGMULT     DB 10,13, ' MULTIPLICACION: $'
    MSGDIVISION DB 10,13, ' DIVISION: $'
    MSGFORMABIN	DB 	" FORMA BINARIA:", 10,13, '$'
    MSGNOT 		DB 10,13, " NOT ", 10,13, '$'
    MSGAND 		DB 10,13, " AND ", 10,13, '$'
    MSGOR 		DB 10,13, " OR ", 10,13, '$'
    MSGXOR 		DB 10,13, " XOR ", 10,13, '$'
    MSGFIBO 	DB ' FIBONACCI: $'
    MSGCORRECT  DB 10,13, 'CONTRASENA CORRECTA $'
    MSGINCORRECT    DB 10,13, 'CONTRASENA INCORRECTA $'
    MSGAUX 		DB 	":", 20H, '$'					; 20H: CODIGO ASCII PARA UN ESPACIO
    SALTOLINEA  DB  10,13, '$'


    NUM1        DW  0
    NUM2        DW  0
    RESULTADO   DB  0
    NUMHX1      DB  0
    NUMHX2      DB 	0

    NUMBIN1		DB 	30H,30H,30H,30H,30H,30H,30H,30H 	; INICIALIZADO EN 30H PARA FACILITAR LA IMPRESION

    NUMFIB1		DW  0
    NUMFIB2		DW  0
    NUMFIBN 	DW  0

    AUX         DW  0
    AUXBYTE		DB 	0
    AUX_DECIMAL DW  0,0,0       ; PARA LEER POR TECLADO UN NUMERO, DIGITO A DIGITO
    AUX_HX      DB  0,0         ; PARA LEER POR TECLADO UN NUMERO HX, DIGITO A DIGITO

    CONTADOR    DB  0
    CONTERRORES DB  0
    MAXDIGITOS  DW  3           ; MAXIMA CANTIDAD DE DIGITOS DE UN NUMERO
    CANTNUMEROS DW  2           ; CANTIDAD DE NUMEROS A PEDIR

    PW          DB 'ARQUCOMP'

    COLOR   DB ?

.CODE
    .STARTUP	; AJUSTA EL SS PARA QUE TENGA LA MISMA DIRECCI??N QUE EL DS

        MOV COLOR, 0EH      ;COLOR: FONDO NEGRO, FUENTE AMARILLA
        CALL CAMBIARCOLOR
        CALL GESTIONARPSWD

    MENU:
        MOV COLOR, 1EH  ; COLOR: FONDO AZUL, FUENTE AMARILLA
        CALL CAMBIARCOLOR

        LEA DX, MSGMENU
        CALL MOSTRARCADENA  ;IMPRIMIENDO
        LEA DX, SALTOLINEA
        CALL MOSTRARCADENA

    OPCIONES:
        LEA DX, MSGOP
        CALL MOSTRARCADENA  ;IMPRIMIENDO

        MOV AH, 01H     ;PIDIENDO LA OPCION DEL MENU
        INT 21H
        OP1:
            CMP AL, "1"
            JNE OP2         ; SE USAN ESTAS DOS CONDICIONES PARA CONTROLAR SALTOS LEJANOS, YA QUE  
            JMP OPCION1		; JE NO PERMITE SALTOS MUY LEJANOS PERO JMP SI.
        OP2:
            CMP AL, "2"
            JNE OP3
            JMP OPCION2
        OP3:
            CMP AL, "3"
            JNE OP4
            JMP OPCION3
        OP4:
            CMP AL, "4"
            JNE OP5
            JMP OPCION4
        OP5:
            CMP AL, "5"
            JMP SALIR
        
    JMP OPCIONES  


    OPCION1:
        MOV COLOR, 6FH
        CALL CAMBIARCOLOR
        LEA DX, MSGNUM1
        CALL MOSTRARCADENA  ;IMPRIMIENDO MENSAJE DE PETICI??N

        CALL LEERNUMERO
        CALL PROCESARNUM
        MOV AX, AUX
        MOV NUM1, AX        

        LEA DX, MSGNUM2
        CALL MOSTRARCADENA  ;IMPRIMIENDO MENSAJE DE PETICI??N

        CALL LEERNUMERO
        CALL PROCESARNUM

        MOV AX, AUX
        MOV NUM2, AX

        CALL SUMAR

        CALL RESTAR

        LEA DX, SALTOLINEA
        CALL MOSTRARCADENA
        LEA DX, MSGESPERARTECLA
        CALL MOSTRARCADENA
        CALL ESPERARTECLA
        JMP MENU

    OPCION2:
        MOV COLOR, 3FH
        CALL CAMBIARCOLOR

        ; PRIMER NUMERO
        LEA DX, MSGNUM1
        CALL MOSTRARCADENA  ;IMPRIMIENDO MENSAJE DE PETICI??N
        CALL LEERNUMERO
        CALL PROCESARNUM
        MOV AX, AUX
        MOV NUM1, AX        

        ; SEGUNDO NUMERO
        LEA DX, MSGNUM2
        CALL MOSTRARCADENA  ;IMPRIMIENDO MENSAJE DE PETICI??N
        CALL LEERNUMERO
        CALL PROCESARNUM
        MOV AX, AUX
        MOV NUM2, AX

        CALL MULTIPLICAR

        CALL DIVIDIR

        LEA DX, SALTOLINEA
        CALL MOSTRARCADENA
        LEA DX, MSGESPERARTECLA
        CALL MOSTRARCADENA
        CALL ESPERARTECLA
        JMP MENU

    OPCION3:
    	MOV COLOR, 4FH
        CALL CAMBIARCOLOR

    	MOV MAXDIGITOS, 2	;SE VA A LEER NUMEROS DE DOS CIFRAS

    	; PRIMER NUMERO
        LEA DX, MSGNUM1
        CALL MOSTRARCADENA  ;IMPRIMIENDO MENSAJE DE PETICI??N
        CALL LEERHX
        CALL PROCESARHX
        MOV NUMHX1, AH        

        ; SEGUNDO NUMERO
        LEA DX, MSGNUM2
        CALL MOSTRARCADENA  ;IMPRIMIENDO MENSAJE DE PETICI??N
        CALL LEERHX
        CALL PROCESARHX
        MOV NUMHX2, AH

     	;IMPRIMIENDO NUMEROS Y SU FORMA BINARIA
     	LEA DX, SALTOLINEA
        CALL MOSTRARCADENA
        CALL MOSTRARCADENA
        LEA DX, MSGFORMABIN
        CALL MOSTRARCADENA

        ;; **PRIMER NUMERO**
        ;PROCESO HEX
        MOV DL, NUMHX1
        CALL MOSTRARHEX

        ;PROCESO BIN
        MOV DL, NUMHX1
		CALL FORMARBINARIO 		; FORMANDO NUMERO BINARIO PARA IMPRESION (ASCII)
		MOV DL, '$'
		MOV NUMBIN1[SI], DL  	; ASEGURANDO FIN DE CADENA
		LEA DX, NUMBIN1
		CALL MOSTRARCADENA 		;IMPRIMIENDO BINARIO

		LEA DX, SALTOLINEA
		CALL MOSTRARCADENA

		;; **SEGUNDO NUMERO**
		;PROCESO HEX
        MOV DL, NUMHX2
        CALL MOSTRARHEX

        ;PROCESO BIN
        MOV DL, NUMHX2
		CALL FORMARBINARIO 		; FORMANDO NUMERO BINARIO PARA IMPRESION (ASCII)
		MOV DL, '$'
		MOV NUMBIN1[SI], DL  	; ASEGURANDO FIN DE CADENA
		LEA DX, NUMBIN1
		CALL MOSTRARCADENA 		;IMPRIMIENDO BINARIO
      	
      	LEA DX, SALTOLINEA
		CALL MOSTRARCADENA


		;; *** OPERACION NOT ***

		LEA DX, MSGNOT 
		CALL MOSTRARCADENA

		; *PRIMER NUMERO*
		MOV DL, NUMHX1
        CALL MOSTRARHEX 		; MOSTRANDO NUMERO HEX MAS DOS PUNTOS (<hex>:  )
        MOV DL, NUMHX1
  		NOT DL 					; APLICANDO NEGACION
		CALL FORMARBINARIO 		; FORMANDO NUMERO BINARIO PARA IMPRESION (ASCII)
		MOV DL, '$'
		MOV NUMBIN1[SI], DL  	; ASEGURANDO FIN DE CADENA
		LEA DX, NUMBIN1
		CALL MOSTRARCADENA 		;IMPRIMIENDO BINARIO
      	
      	LEA DX, SALTOLINEA
		CALL MOSTRARCADENA

		; *SEGUNDO NUMERO*
		MOV DL, NUMHX2
        CALL MOSTRARHEX 		; MOSTRANDO NUMERO HEX MAS DOS PUNTOS (<hex>:  )
        MOV DL, NUMHX2
       	NOT DL 					; APLICANDO NEGACION
		CALL FORMARBINARIO 		; FORMANDO NUMERO BINARIO PARA IMPRESION (ASCII)
		MOV DL, '$'
		MOV NUMBIN1[SI], DL  	; ASEGURANDO FIN DE CADENA
		LEA DX, NUMBIN1
		CALL MOSTRARCADENA 		; IMPRIMIENDO BINARIO
      	
      	LEA DX, SALTOLINEA
		CALL MOSTRARCADENA


		;; *** OPERACION AND ***

		LEA DX, MSGAND 
		CALL MOSTRARCADENA

		MOV DL, NUMHX1
		AND DL, NUMHX2 			; APLICANDO AND ENTRE LOS DOS NUMEROS

		MOV RESULTADO, DL 		; GUARDANDO RESULTADO PARA MAS TARDE
		CALL MOSTRARHEX 		; PARA MOSTRAR EL VALOR HEXADECIMAL OBTENIDO

		MOV DL, RESULTADO
		CALL FORMARBINARIO 		; FORMANDO EL VALOR OBTENIDO EN BINARIO
		MOV DL, '$'
		MOV NUMBIN1[SI], DL  	; ASEGURANDO FIN DE CADENA
		
		LEA DX, NUMBIN1
		CALL MOSTRARCADENA 		; IMPRIMIENDO BINARIO

		LEA DX, SALTOLINEA
		CALL MOSTRARCADENA


		;; *** OPERACION OR ***
		
		LEA DX, MSGOR 
		CALL MOSTRARCADENA

		MOV DL, NUMHX1
		OR DL, NUMHX2 			; APLICANDO OR ENTRE LOS DOS NUMEROS

		MOV RESULTADO, DL 		; GUARDANDO RESULTADO PARA MAS TARDE
		CALL MOSTRARHEX 		; PARA MOSTRAR EL VALOR HEXADECIMAL OBTENIDO

		MOV DL, RESULTADO
		CALL FORMARBINARIO 		; FORMANDO EL VALOR OBTENIDO EN BINARIO
		MOV DL, '$'
		MOV NUMBIN1[SI], DL  	; ASEGURANDO FIN DE CADENA

		LEA DX, NUMBIN1
		CALL MOSTRARCADENA 		; IMPRIMIENDO BINARIO

		LEA DX, SALTOLINEA
		CALL MOSTRARCADENA


		;; *** OPERACION XOR ***
		
		LEA DX, MSGXOR 
		CALL MOSTRARCADENA

		MOV DL, NUMHX1
		XOR DL, NUMHX2 			; APLICANDO XOR ENTRE LOS DOS NUMEROS

		MOV RESULTADO, DL 		; GUARDANDO RESULTADO PARA MAS TARDE
		CALL MOSTRARHEX 		; PARA MOSTRAR EL VALOR HEXADECIMAL OBTENIDO

		MOV DL, RESULTADO
		CALL FORMARBINARIO 		; FORMANDO EL VALOR OBTENIDO EN BINARIO
		MOV DL, '$'
		MOV NUMBIN1[SI], DL  	; ASEGURANDO FIN DE CADENA

		LEA DX, NUMBIN1
		CALL MOSTRARCADENA 		; IMPRIMIENDO BINARIO

		LEA DX, SALTOLINEA
		CALL MOSTRARCADENA
		LEA DX, MSGESPERARTECLA
        CALL MOSTRARCADENA
      	CALL ESPERARTECLA
		JMP MENU
        
    OPCION4:
    	MOV COLOR, 5FH
        CALL CAMBIARCOLOR
    	CALL FIBONACCI

    	LEA DX, SALTOLINEA
        CALL MOSTRARCADENA
        LEA DX, MSGESPERARTECLA
        CALL MOSTRARCADENA
        CALL ESPERARTECLA
        JMP MENU
    SALIR:
        MOV AX, 4C00H
        INT 21H


    ;
    ;; PROCEDIMIENTOS O SUBRUTINAS
    ;_________________________________________________________________________________________________________________

    ;;  PERMITE MOSTRAR POR PANTALLA LA CADENA CUYA DIRECCION SE ENCUENTRA EN DX.
    MOSTRARCADENA PROC
        MOV AH, 09H
        INT 21H
        RET
    MOSTRARCADENA ENDP

    ;;  PERMITE MOSTRAR POR PANTALLA EL CARACTER QUE SE ENCUENTRA EN DL.
    MOSTRARCARACTER PROC
    	MOV AH, 02H         		;SERVICIO DE IMPRESION DE CARACTER
        INT 21H
        RET
    MOSTRARCARACTER ENDP

    ;; ESPERA QUE SE PRESIONE UNA TECLA PARA CONTINUAR
    ESPERARTECLA PROC
        MOV AH, 00H
        INT 16H
        RET
    ESPERARTECLA ENDP


    ; ;  SE LEE UNA CONTRASE?A DE 8 CARACTERES DIGITADA POR EL USUARIO Y SE COMPARA CON LA QUE EST? ALMACENADA EN MEMORIA.
    GESTIONARPSWD PROC
                
        INICIARLECTURA:
            MOV BX, OFFSET PW   	;OBTENIENDO DIRECCI?N DE INICIO DE CONTRASE?A ALMACENADA
            MOV CX, 50          	;INICIALIZANDO CONTADOR

            LEA DX, MSG0
            CALL MOSTRARCADENA      ;IMPRIMIENDO
            
            LEER: 
                MOV AH, 08H     	;LEYENDO CARACTER
                INT 21H

                CMP AL, 0DH         ; SE COMPARA CON EL VALOR DE LA TECLA ENTER
                JE FINLECTURA

                PUSH AX         	;GUARDANDO CARACTER INGRESADO EN LA PILA
                PUSH [BX]       	;GUARDANDO CARACTER DE CONTRASE?A ALMACENADA EN LA PILA
                INC BX          	;INCR EN 1 A BX PARA OBTENER SGTE CARACTER DE CONTRASE?A ALMACENADA EN LA PROX. ITERACI?N
                
                MOV AH, 02H         ;SERVICIO DE IMPRESI?N DE CARACTER
                MOV DL, '*'
                INT 21H

            LOOP LEER       

        FINLECTURA:
            MOV CX, 8           	;INICIALIZANDO CONTADOR

        COMPARAR: 
            POP AX          		;OBTENIENDO DE LA PILA UN CARACTER INGRESADO
            POP BX          		;OBTENIENDO DE LA PILA UN CARACTER DE LA CONTRASE?A ALMACENADA
            CMP AL, BL
            JNE ERROR       		;SI SON DIFERENTES
        LOOP COMPARAR
        
        JMP MENU            

        ERROR:
            LEA DX, MSGINCORRECT    
            CALL MOSTRARCADENA  	;IMPRIMIENDO
            ADD CONTERRORES, 1
            CMP CONTERRORES, 3
            JNE INICIARLECTURA      ; SI NO SE HAN CUMPLIDO LAS TRES OPORTUNIDADES
            
            JMP SALIR

    GESTIONARPSWD ENDP

    ;;  LEE UN NUMERO CON UNA CANTIDAD M?XIMA DE DIGITOS DADA POR 'MAXDIGITOS'
    ;   CADA DIGITO SE ALMACENA EN UNA POSICION DIFERENTE DE 'AUX_DECIMAL'.
    LEERNUMERO PROC
    
        MOV SI, 0               	; INICIALIZANDO APUNTADOR
        MOV CX, MAXDIGITOS      	; INICIALIZANDO CONTADOR
        CICLO:
            MOV AH, 01H         
            INT 21H             	; SE TOMA CARACTER DESDE TECLADO

            CMP AL, 0DH         	; SE COMPARA CON EL VALOR DE LA TECLA ENTER
            JE SALIRPROC

            SUB AL, 30H         	; CONVIRTIENDO A DECIMAL
            MOV AH, 0
            MOV AUX_DECIMAL[SI], AX     ; ALMACENANDO EL DIGITO EN AUX_DECIMAL EN LA POSICION DADA POR 'SI' 
            INC SI              	; SI = SI+1
            INC SI              	; INCREMENTANDO 2 VECES YA QUE CADA ELEMENTO DE AUX_DECIMAL ALMACENA 16 BITS (DW)
        LOOP CICLO
        SALIRPROC:
            RET
    LEERNUMERO ENDP

    LEERHX PROC
    
        MOV SI, 0               	; INICIALIZANDO APUNTADOR
        MOV CX, MAXDIGITOS      	; INICIALIZANDO CONTADOR
        CICLOHX:
            MOV AH, 01H         
            INT 21H             	; SE TOMA CARACTER DESDE TECLADO

            CMP AL, 0DH         	; SE COMPARA CON EL VALOR DE LA TECLA ENTER
            JE SALIRPROCHX

            CMP AL, 30H			
            JS CICLOHX				; SI SE INGRESA UN CARACTER MENOR A 0, NO HACE NADA
            CMP AL, 3AH
            JNS MAYORA9

            SUB AL, 30H         	; CONVIRTIENDO A HX
	        JMP ALMACENAR

            MAYORA9:
	            CMP AL, 41H
	            JS CICLOHX 			;SI SE INGRESA UN CARACTER MAYOR A 9 PERO MENOR A A, NO HACE NADA
	            CMP AL, 47H
	            JNS CICLOHX			; SI SE INGRESA UN CARACTER MAYOR A F, NO HACE NADA			

	            SUB AL, 37H         ; CONVIRTIENDO A HX
	            JMP ALMACENAR


            ALMACENAR:
                MOV AUX_HX[SI], AL  ; ALMACENANDO EL DIGITO EN AUX_DECIMAL EN LA POSICION DADA POR 'SI' 
            INC SI              	; SI = SI+1
        LOOP CICLOHX
        SALIRPROCHX:
            RET
    LEERHX ENDP


    ;;  TOMA EL NUMERO PREVIAMENTE DIGITADO QUE SE ENCUENTRA EN 'AUX_DECIMAL'. SE ORGANIZA COMO UN UNICO VALOR DECIMAL Y SE ALMACENA EN 'AUX', TENIENDO EN CUENTA LA CANTIDAD DE CIFRAS DE ?STE.
    PROCESARNUM PROC
        
        MOV AUX, 0000H      ; INICIALIZANDO 'AUX' YA QUE ESTE VA A ALMACENAR EL NUMERO COMPLETO
        COMPARARCANTIDAD:
            CMP SI, 6       ; EN EL CASO DE QUE 'SI' SEA IGUAL A 6, ES PORQUE SE INGRES? UN NUMERO DE TRES DIGITOS
            JE TRESCIFRAS
            CMP SI, 4
            JE DOSCIFRAS
            CMP SI, 2
            JE UNACIFRA
        
        ;SI EL NUMERO ES DE 3 CIFRAS, SE TRATA EL PRIMER DIGITO, SE MULTIPLICA POR 100 SE SUMA A LA VARIABLE Y SE PASA A TRATAR EL SEGUNDO DIGITO.
        ;SI EL NUMERO ES DE 2 CIFRAS, SE TRATA EL PRIMER DIGITO, SE MULTIPLICA POR 10 SE SUMA A LA VARIABLE Y SE SUMA EL SEGUNDO DIGITO A LA VARIABLE.
        ;SI EL NUMERO ES DE 1 CIFRAS, SE SUMA A LA VARIABLE.

        TRESCIFRAS:
            MOV SI, 0
        CENTENA:
            MOV AX, AUX_DECIMAL[SI] ;OBTENIENDO EL VALOR ALMACENADO EN LA POSICION DADA POR 'SI' DE AUX_DECIMAL
            MOV BH, 0
            MOV BL, 100
            MUL BX
            ADD AUX, AX
            ADD SI, 2               ;INCREMENTANDO EN 2 A 'SI' PARA PASAR A PROCESAR LA SIGUIENTE CIFRA
            JMP DECENA              ;SALTANDO A PROCESAR LA DECENA, CON SI = 2, OBVIAMENTE.
        
        DOSCIFRAS:                  
            MOV SI, 0
        DECENA:
            MOV AX, AUX_DECIMAL[SI]
            MOV BH, 0
            MOV BL, 10
            MUL BX
            ADD AUX, AX
            ADD SI, 2
            JMP UNIDAD

        UNACIFRA:
            MOV SI, 0
        UNIDAD:
            MOV AX, AUX_DECIMAL[SI]
            ADD AUX, AX
 
        RET
    PROCESARNUM ENDP

    ;;  TOMA EL NUMERO DE DOS CIFRAS PREVIAMENTE DIGITADO QUE SE ENCUENTRA EN 'AUX_HX'. SE ORGANIZA COMO UN UNICO VALOR HEXADECIMAL QUE QUEDA ALMACENADO EN AH.
    PROCESARHX PROC
    	MOV CL, 4
    	MOV AH, AUX_HX[0]
    	MOV AL, AUX_HX[1]
    	SHL AH, CL 			; DESPLAZANDO EL VALOR DE AUX_HX EN LA POS. 0, 4 BITS A LA IZQUIERDA.
    	XOR AH, AL			; PRIMEROS 4 BITS DE AH: PRIMER CIFRA. SEGUNDOS 4 BITS DE AH: SEGUNDA CIFRA.
    	RET
    PROCESARHX ENDP

    MOSTRARHEX PROC
    	CALL HEX_TO_CAD 		; CONVIRTIENDO NUM HEX EN CADENA
        MOV AL, MSGAUX
        MOV AUXBYTE[2], AL 		; FORMANDO EL MENSAJE "<HX>:  "
        MOV DL, '$'				
        MOV AUXBYTE[4], DL 		; ASEGURANDO FIN DE CADENA
	    LEA DX, AUXBYTE
	    CALL MOSTRARCADENA 		;IMPRIMIENDO NUMERO HX
	    RET
    MOSTRARHEX ENDP

	; CONVIERTE EL NUMERO HEX ALMACENADO EN DL A UNA CADENA QUE SE ALMACENA EN AUXBYTE, SIN SIMBOLO DE FIN DE CADENA POR SI SE NECESITA CONCATENAR ALGO M??S..
	HEX_TO_CAD PROC NEAR
		LEA BX, AUXBYTE 	 ; GUARDANDO DIRECCI??N DE VARIABLE
	    MOV  DH, DL          ; GUARDANDO UNA COPIA PARA M??S TARDE

	    MOV  CL, 4
	    SHR  DL, CL          ; COLOCANDO LA PARTE ALTA DE DL (PRIMER DIGITO) EN TODO EL REGISTRO

	    CALL UNDIGITO  

	    AND  DH, 0FH         ; LIMPIANDO LA PARTE ALTA DE DH, SOLO DEJANDO LA PARTE BAJA (SEGUNDO DIGITO)
	    MOV  DL, DH
	    CALL UNDIGITO

	    RET     

	HEX_TO_CAD ENDP
	
	; PROCEDIMIENTO AUXILIAR. ENTRADA: DL = 0..F
	UNDIGITO PROC NEAR
	    CMP   DL, 9
	    JBE   DIGITO 	; SALTO CONDICIONAL: SOLO SI EL DIGITO ES MENOR O IGUAL A 9
	    ADD   DL, 'A'-10  - '0'
		DIGITO:
		    ADD   DL, '0' 	; CONVIRTIENDO EN CARACTER
		    MOV [BX], DL
		    INC BX
	    RET
	UNDIGITO ENDP


    ;; AL VALOR ALMACENADO EN 'NUM1', SE LE SUMA EL VALOR ALMACENADO EN 'NUM2' Y SE MUESTRA EL RESULTADO.
    SUMAR PROC
        MOV AX, NUM1        
        ADD AX, NUM2        ;SUMANDO

        ;CONVIRTIENDO RESULTADO EN CADENA
        LEA BX, RESULTADO
        CALL ITOA

        ; MOSTRANDO RESULTADO
        LEA DX, MSGSUMA
        CALL MOSTRARCADENA
        LEA DX, RESULTADO
        CALL MOSTRARCADENA
        RET
    SUMAR ENDP


    ;; AL VALOR ALMACENADO EN 'NUM1', SE LE RESTA EL VALOR ALMACENADO EN 'NUM2' Y SE MUESTRA EL RESULTADO.
    ;   SI EL VALOR ES NEGATIVO, SE UTILIZA EL MENSAJE RESPECTIVO.
    RESTAR PROC

        MOV AX, NUM1
        CMP AX, NUM2
        JNS RESPOSITIVO
        JS RESNEGATIVO

        RESPOSITIVO:
            MOV AX, NUM1
            SUB AX, NUM2        ;RESTANDO

            ;CONVIRTIENDO RESULTADO EN CADENA
            LEA BX, RESULTADO
            CALL ITOA

            ; MOSTRANDO RESULTADO
            LEA DX, MSGRESTA
            CALL MOSTRARCADENA
            LEA DX, RESULTADO
            CALL MOSTRARCADENA
            JMP SALIRRESTA
        RESNEGATIVO:
            MOV AX, NUM2        
            SUB AX, NUM1        ;RESTANDO

            ;CONVIRTIENDO RESULTADO EN CADENA
            LEA BX, RESULTADO
            CALL ITOA

            ; MOSTRANDO RESULTADO
            LEA DX, MSGRESTANEG
            CALL MOSTRARCADENA
            LEA DX, RESULTADO
            CALL MOSTRARCADENA
        SALIRRESTA:
            RET
    RESTAR ENDP


    ;; AL VALOR ALMACENADO EN 'NUM1', SE LE MULTIPLICA EL VALOR ALMACENADO EN 'NUM2' Y SE MUESTRA EL RESULTADO.
    MULTIPLICAR PROC
    	MOV AX, NUM1 	; ASIGNANDO PRIMER FACTOR        
        MUL NUM2 		; REALIZANDO MULTIPLICACION

        ;CONVIRTIENDO RESULTADO EN CADENA
        LEA BX, RESULTADO
        CALL ITOA

        ; MOSTRANDO RESULTADO
        LEA DX, MSGMULT
        CALL MOSTRARCADENA
        LEA DX, RESULTADO
        CALL MOSTRARCADENA
        RET
    MULTIPLICAR ENDP


    ;; AL VALOR ALMACENADO EN 'NUM1', SE LE DIVIDE EL VALOR ALMACENADO EN 'NUM2' Y SE MUESTRA EL RESULTADO.
    DIVIDIR PROC
        XOR AX, AX 		; LIMPIANDO EL REGISTRO
        MOV AX, NUM1	; ASIGNANDO DIVIDENDO

        ;CONVERSI??N NECESARIA YA QUE EN LA DIVISION, EL DIVIDENDO DEBE SER DE MAYOR TAMA??O QUE EL DIVISOR.
        MOV DL, BYTE PTR NUM2[0] 		;ASIGNANDO DIVISOR. COMO NUM2 ES DE TIPO WORD, PERO SOLO ALMACENA 1 BYTE, PUEDO HACER LA CONVERSI??N.
        
        DIV DL    	; REALIZANDO DIVISION ENTRE EL SEGUNDO NUMERO (DIVISOR)

        ;CONVIRTIENDO RESULTADO EN CADENA
        XOR AH, AH 		;EL COCIENTE QUEDA EN AL, ENTONCES LIMPIO AH PARA PODER PROCESAR AX COMO RESULTADO.
        LEA BX, RESULTADO
        CALL ITOA

        ; MOSTRANDO RESULTADO
        LEA DX, MSGDIVISION
        CALL MOSTRARCADENA
        LEA DX, RESULTADO
        CALL MOSTRARCADENA
        RET
    DIVIDIR ENDP

    ;; CONVIERTE EL VALOR ALMACENADO EN AX, EN UNA CADENA DE CARACTERES PARA FACILITAR LA IMPRESI?N.
    ITOA PROC NEAR
        XOR CX,CX  ;CX = 0

        ITOA_1:
            CMP AX,0   ; EL CICLO ITOA_1 EXTRAE LOS DIGITOS DEL
            JE ITOA_2  ; MENOS AL MAS SIGNIFICATIVO DE AX Y LOS
                     ; GUARDA EN EL STACK. AL FINALIZAR EL 
            XOR DX,DX  ; CICLO EL DIGITO MAS SIGNIFICATIVO ESTA
            PUSH BX    ; ARRIBA DEL STACK.
            MOV BX,10  ; CX CONTIENE EL NUMERO DE DIGITOS
            DIV BX
            POP BX
            PUSH DX
            INC CX
            JMP ITOA_1

        ITOA_2:
            CMP CX,0    ; ESTA SECCION MANEJA EL CASO CUANDO
            JA ITOA_3   ; EL NUMERO A CONVERTIR (AX) ES 0.
            MOV AX,'0'  ; EN ESTE CASO, EL CICLO ANTERIOR
            MOV [BX],AX ; NO GUARDA VALORES EN EL STACK Y
            INC BX      ; CX TIENE EL VALOR 0
            JMP ITOA_4

        ITOA_3:
            POP AX      ; EXTRAEMOS LOS NUMERO DEL STACK
            ADD AX,30H  ; LO PASAMOS A SU VALOR ASCII
            MOV [BX],AX ; LO GUARDAMOS EN LA CADENA FINAL
            INC BX
            LOOP ITOA_3

        ITOA_4:
            MOV AX,'$' 
            MOV [BX],AX ; TERMINAR CADENA CON '$' PARA IMPRIMIRLA CON LA INT21H/AH=9
        RET
    ITOA ENDP

    ; FORMA UN NUMERO BINARIO LISTO PARA LA IMPRESION (CODIGO ASCII), CON EL NUMERO HX ALMACENADO EN DL, EL RESULTADO QUEDA ALMACENADO EN NUMBIN1
    FORMARBINARIO PROC

    	LEA BX, NUMBIN1
    	CALL LIMPIARARRAY

    	MOV SI, 0			 ; SE RECORRER?? EL ARRAY PARTIENDO DE LA POSICION CERO
	    MOV  DH, DL          ; GUARDANDO UNA COPIA PARA M??S TARDE

	    MOV  CL, 4
	    SHR  DL, CL          ; COLOCANDO LA PARTE ALTA DE DL (PRIMER DIGITO) EN TODO EL REGISTRO

	   	MOV CX, 2 			 ; INICIALIZANDO CONTADOR
    	COMPARARBYTE:
    		CERO:
		    	CMP DL, 00H
		    	JNE UNO
		    	JMP ASIGCERO
	    	UNO:
		    	CMP DL, 01H
		    	JNE DOS
		    	JMP ASIGUNO
	    	DOS:
		    	CMP DL, 02H
		    	JNE TRES
		    	JMP ASIGDOS
	    	TRES:
		    	CMP DL, 03H
		    	JNE CUATRO
		    	JMP ASIGTRES
	    	CUATRO:
		    	CMP DL, 04H
		    	JNE CINCO
		    	JMP ASIGCUATRO
	    	CINCO:
		    	CMP DL, 05H
		    	JNE SEIS
		    	JMP ASIGCINCO
	    	SEIS:
		    	CMP DL, 06H
		    	JNE SIETE
		    	JMP ASIGSEIS
	    	SIETE:
		    	CMP DL, 07H
		    	JNE OCHO
		    	JMP ASIGSIETE
	    	OCHO:
		    	CMP DL, 08H
		    	JNE NUEVE
		    	JMP ASIGOCHO
	    	NUEVE:
		    	CMP DL, 09H
		    	JNE DIEZ
		    	JMP ASIGNUEVE
	    	DIEZ:
		    	CMP DL, 0AH
		    	JNE ONCE
		    	JMP ASIGDIEZ
	    	ONCE:
		    	CMP DL, 0BH
		    	JNE DOCE
		    	JMP ASIGONCE
	    	DOCE:
		    	CMP DL, 0CH
		    	JNE TRECE
		    	JMP ASIGDOCE
	    	TRECE:
		    	CMP DL, 0DH
		    	JNE CATORCE
		    	JMP ASIGTRECE
	    	CATORCE:
		    	CMP DL, 0EH
		    	JNE QUINCE
		    	JMP ASIGCATORCE
	    	QUINCE:
		    	CMP DL, 0FH
		    	JMP ASIGQUINCE

		    PUENTE:
		    	JMP COMPARARBYTE

	    	; SE ASIGNA EL VALOR HX DEL CODIGO ASCCI DE CADA BIT PARA POSTERIORMENTE MOSTRAR EN PANTALLA
	    	ASIGNACION:
		    	ASIGCERO:
		    		ADD SI, 4
			    	JMP FINASIGNACION
		    	ASIGUNO:
		    		ADD SI, 3
			    	MOV NUMBIN1[SI], 31H
			    	INC SI
			    	JMP FINASIGNACION
		    	ASIGDOS:
		    		ADD SI, 2
		    		MOV NUMBIN1[SI], 31H
			    	ADD SI, 2
			    	JMP FINASIGNACION
		    	ASIGTRES:
		    		ADD SI, 2
		    		MOV NUMBIN1[SI], 31H
		    		INC SI
			    	MOV NUMBIN1[SI], 31H
			    	INC SI
			    	JMP FINASIGNACION
		    	ASIGCUATRO:
		    		INC SI
		    		MOV NUMBIN1[SI], 31H
			    	ADD SI, 3
			    	JMP FINASIGNACION
		    	ASIGCINCO:
		    		INC SI
		    		MOV NUMBIN1[SI], 31H
		    		ADD SI, 2
			    	MOV NUMBIN1[SI], 31H
			    	INC SI
			    	JMP FINASIGNACION
		    	ASIGSEIS:
		    		INC SI
		    		MOV NUMBIN1[SI], 31H
			    	INC SI
			    	MOV NUMBIN1[SI], 31H
			    	ADD SI, 2
			    	JMP FINASIGNACION
		    	ASIGSIETE:
		    		INC SI
		    		MOV NUMBIN1[SI], 31H
			    	INC SI
			    	MOV NUMBIN1[SI], 31H
			    	INC SI
			    	MOV NUMBIN1[SI], 31H 
			    	INC SI
			    	JMP FINASIGNACION
		    	ASIGOCHO:
		    		MOV NUMBIN1[SI], 31H
			    	ADD SI, 4
			    	JMP FINASIGNACION
		    	ASIGNUEVE:
		    		MOV NUMBIN1[SI], 31H
			    	ADD SI, 3
			    	MOV NUMBIN1[SI], 31H
			    	INC SI
			    	JMP FINASIGNACION
		    	ASIGDIEZ:
		    		MOV NUMBIN1[SI], 31H
			    	ADD SI, 2
			    	MOV NUMBIN1[SI], 31H
			    	ADD SI, 2
			    	JMP FINASIGNACION
		    	ASIGONCE:
		    		MOV NUMBIN1[SI], 31H
			    	ADD SI, 2
			    	MOV NUMBIN1[SI], 31H
			    	INC SI
			    	MOV NUMBIN1[SI], 31H 
			    	INC SI
			    	JMP FINASIGNACION
		    	ASIGDOCE:
		    		MOV NUMBIN1[SI], 31H
			    	INC SI
			    	MOV NUMBIN1[SI], 31H
			    	ADD SI, 3
			    	JMP FINASIGNACION
		    	ASIGTRECE:
		    		MOV NUMBIN1[SI], 31H
			    	INC SI
			    	MOV NUMBIN1[SI], 31H
			    	ADD SI, 2
			    	MOV NUMBIN1[SI], 31H 
			    	INC SI
			    	JMP FINASIGNACION
		    	ASIGCATORCE:
		    		MOV NUMBIN1[SI], 31H
			    	INC SI
			    	MOV NUMBIN1[SI], 31H
			    	INC SI
			    	MOV NUMBIN1[SI], 31H 
			    	ADD SI, 2
			    	JMP FINASIGNACION
		    	ASIGQUINCE:
		    		MOV NUMBIN1[SI], 31H
			    	INC SI
			    	MOV NUMBIN1[SI], 31H
			    	INC SI
			    	MOV NUMBIN1[SI], 31H 
			    	INC SI
			    	MOV NUMBIN1[SI], 31H
			    	INC SI
		    FINASIGNACION:
	    		AND  DH, 0FH         ; LIMPIANDO LA PARTE ALTA DE DH, SOLO DEJANDO LA PARTE BAJA (SEGUNDO DIGITO)
	    		MOV  DL, DH 		 ; GUARDANDO ESE SEGUNDO DIGITO EN DL PARA LA SEGUNDA ITERACION
	    		DEC CX
	    		CMP CX, 0
	    		JE SALIRBIN
	    		JMP PUENTE
	    SALIRBIN:
	    	RET
    FORMARBINARIO ENDP

    ;; CALCULA E IMPRIME LOS PRIMEROS 15 ELEMENTOS DE LA SUCESI??N FIBONACCI
    FIBONACCI PROC
    	MOV NUMFIB1, 01H
    	MOV NUMFIB2, 01H

    	;IMPRIMIENDO PRIMER ELEMENTO
    	MOV RESULTADO, 00H
    	MOV AX, NUMFIB1
    	LEA BX, RESULTADO
    	CALL ITOA
    	LEA DX, RESULTADO
    	CALL MOSTRARCADENA

		;IMPRIMIENDO UNA COMA (,) PARA SEPARAR CADA ELEMENTO DE LA SUCESI??N
    	MOV DL, ','
    	MOV RESULTADO, 00H
    	MOV AH,02H
    	INT 21H

    	;IMPRIMIENDO SEGUNDO ELEMENTO
    	MOV RESULTADO, 00H
    	MOV AX, NUMFIB2
    	LEA BX, RESULTADO
    	CALL ITOA
    	LEA DX, RESULTADO
    	CALL MOSTRARCADENA

    	MOV CONTADOR, 0DH
    	FIBO:
    		CMP CONTADOR, 0
    		JE SALIRFIB
    	 	;IMPRIMIENDO UNA COMA (,) PARA SEPARAR CADA ELEMENTO DE LA SUCESI??N
    	 	MOV DL, ','
    	 	MOV RESULTADO, 00H
    	 	MOV AH,02H
    	 	INT 21H

    	 	; CALCULANDO SIGUIENTE ELEMENTO
    	 	MOV AX, NUMFIB1
    	 	ADD AX, NUMFIB2
    	 	MOV NUMFIBN, AX

    	 	; IMPRIMIENDO
    	 	MOV AX, NUMFIBN
	    	LEA BX, RESULTADO
	    	CALL ITOA 
	    	LEA DX, RESULTADO
	    	CALL MOSTRARCADENA

	    	MOV AX, NUMFIB2
	    	MOV DX, NUMFIBN
	    	MOV NUMFIB1, AX
	    	MOV NUMFIB2, DX

	    	DEC CONTADOR 		;DECREMENTA EN 1
	    	JMP FIBO
	    SALIRFIB:
    		RET
    FIBONACCI ENDP

    ;;  USADO PARA 'LIMPIAR' EL ARRAY QUE ALMACENA LOS NUMEROS BINARIOS (ASCII)
    LIMPIARARRAY PROC
    	MOV CX, 8
    	LIMPIAR:
	    	MOV [BX], 30H
	    	INC BX
	    LOOP LIMPIAR
	    RET
    LIMPIARARRAY ENDP

    ; ;  CAMBIA EL COLOR DE FONDO Y DE LA FUENTE TENIENDO EN CUENTA LOS VALORES ALMACENADOS EN COLOR.
    CAMBIARCOLOR PROC

        ; FIJA A MODO DE VIDEO: LIMPIA LA PANTALLA
        MOV AX, 3
        INT 10H    

        ;ACTIVA LOS 16 COLORES
        MOV AX, 1003H
        MOV BX, 0
        INT 10H
        
        ;CAMBIA EL COLOR DE FONDO
        MOV AH, 06H    
        XOR AL, AL     
        XOR CX, CX     
        MOV DX, 184FH  
        MOV BH, COLOR 
        INT 10H
        RET

    CAMBIARCOLOR ENDP


END