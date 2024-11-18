from machine import Pin, PWM
import time
#variabile receiver
receiverLeftMotor = Pin(16, Pin.IN)
receiverRightMotor = Pin(17, Pin.IN)
rand = 0
timpMotorStang = 0
timpMotorDrept = 0
#variabile hbridge
LeftF = Pin(18, Pin.OUT)
LeftB = Pin(19, Pin.OUT)
RightF = Pin(20, Pin.OUT)
RightB = Pin(21, Pin.OUT)
LeftS = PWM(Pin(22, Pin.OUT), 1000)
RightS = PWM(Pin(26, Pin.OUT), 1000)
#prescaler print
prescaler = 20
indexPrescaler = 0
#viteza calculata
vitezaS = 0
vitezaD = 0
#duty calcular
dutyD = 0
dutyS = 0
#counter citiri invalide
invalid = 0
#"main"
while True:
    #citire de la receiver
    if rand == 0:
        timpMotorStang = machine.time_pulse_us(receiverLeftMotor, 1, 1000000)
        rand = 1
    else:
        timpMotorDrept = machine.time_pulse_us(receiverRightMotor, 1, 1000000)
        rand = 0
    
    #verificare valori valide
    if timpMotorStang > 1000 and timpMotorDrept > 1000:
        #scalare valori
        vitezaS = (timpMotorStang-1450)*2//7
        vitezaD = (timpMotorDrept-1450)*2//7
        #limitare valori
        if vitezaS < -100:
            vitezaS = -100
        elif vitezaS > 100:
            vitezaS = 100
        if vitezaD < -100:
            vitezaD = -100
        elif vitezaD > 100:
            vitezaD = 100
        #transformare in duty
        dutyD = abs(vitezaD)*65536//100
        dutyS = abs(vitezaS)*65536//100
        #aplicare duty si directie
        if vitezaS>=0:
            LeftF.value(1)
            LeftB.value(0)
        else:
            LeftF.value(0)
            LeftB.value(1)
        if vitezaD>=0:
            RightF.value(1)
            RightB.value(0)
        else:
            RightF.value(0)
            RightB.value(1)
        LeftS.duty_u16(dutyS)
        RightS.duty_u16(dutyD)
    else:
        invalid+=1
    #printare cu prescaler
    if prescaler == indexPrescaler:
        print(str(vitezaS)+" "+str(vitezaD)+" "+str(invalid))
        #print(str(dutyS)+" "+str(dutyD))
        indexPrescaler = 0
    indexPrescaler+=1
    #sleep ca sa incep citirea urmatorului canal la urmatoarea sincronizare
    time.sleep_ms(2)
