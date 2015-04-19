/*********************************************************************************************
This experiment enables the user to control the motion of the bot wirelessly through Serial
Communication from the PC.UART0 is dedicated to Wireless Serial communication using on-board
X-bee module.

Byte commands for respective directions are as follows:

0x38 - - - - > FORWARD
0x32 - - - - > BACKWARD
0x34 - - - - > LEFT
0x36 - - - - > RIGHT
0x35 - - - - > STOP
0x31 - - - - > SOFT LEFT
0x33 - - - - > SOFT RIGHT
0x37 - - - - > BUZZER ON
0x39 - - - - > BUZZER OFF

A special feature that is added to our bot is programmed stop immediately as soon as it faces an obstacle
150mm ahead and beep once using sharp sensors.
Thus if the user doesn't give any command to the bot, it will save itself from the danger.

**********************************************************************************************/

#define F_CPU 14745600
#include<avr/io.h>
#include<avr/interrupt.h>
#include<util/delay.h>
#include <math.h>

unsigned char data_from_udr;                         //to store received data_from_udr from UDR1
unsigned char ADC_Conversion(unsigned char);
unsigned char ADC_Value;
unsigned char sharp, distance, adc_reading;
unsigned int value;
float BATT_Voltage, BATT_V;


void adc_pin_config (void)  //ADC pin configuration
{
	DDRF = 0x00;          //set PORTF direction as input
	PORTF = 0x00;         //set PORTF pins floating
	DDRK = 0x00;          //set PORTK direction as input
	PORTK = 0x00;         //set PORTK pins floating
}
void buzzer_pin_config (void) //Buzzer Pin Configuration
{
	DDRC = DDRC | 0x08;		    //Setting PORTC 3 as output
	PORTC = PORTC & 0xF7;		//Setting PORTC 3 logic low to turnoff buzzer
}

void motion_pin_config (void) //Motion Pin Configuration
{
	DDRA = DDRA | 0x0F;
	PORTA = PORTA & 0xF0;
	DDRL = DDRL | 0x18;        //Setting PL3 and PL4 pins as output for PWM generation
	PORTL = PORTL | 0x18;      //PL3 and PL4 pins are for velocity control using PWM.
}


void port_init() //Function to initialize ports
{
	adc_pin_config();
	motion_pin_config();
	buzzer_pin_config();
}

void adc_init()//Function to Initialize ADC
{
	ADCSRA = 0x00;
	ADCSRB = 0x00;		//MUX5 = 0
	ADMUX = 0x20;		//Vref=5V external --- ADLAR=1 --- MUX4:0 = 0000
	ACSR = 0x80;
	ADCSRA = 0x86;		//ADEN=1 --- ADIE=1 --- ADPS2:0 = 1 1 0
}

//This Function accepts the Channel Number and returns the corresponding Analog Value
unsigned char ADC_Conversion(unsigned char Ch)
{
	unsigned char a;
	if(Ch>7)
	{
		ADCSRB = 0x08;
	}
	Ch = Ch & 0x07;
	ADMUX= 0x20| Ch;
	ADCSRA = ADCSRA | 0x40;		//Set start conversion bit
	while((ADCSRA&0x10)==0);	//Wait for ADC conversion to complete
	a=ADCH;
	ADCSRA = ADCSRA|0x10; //clear ADIF (ADC Interrupt Flag) by writing 1 to it
	ADCSRB = 0x00;
	return a;
}


// This Function calculates the actual distance in millimeters(mm) from the input
// analog value of Sharp Sensor.

unsigned int Sharp_GP2D12_estimation(unsigned char adc_reading)
{
	float distance;
	unsigned int distanceInt;
	distance = (int)(10.00*(2799.6*(1.00/(pow(adc_reading,1.1546)))));
	distanceInt = (int)distance;
	if(distanceInt>800)
	{
		distanceInt=800;
	}
	return distanceInt;
}

//Function used for setting motor's direction with active sensors
int motion_set (unsigned char Direction)
{
	int f=1;
	unsigned char PortARestore = 0;
	Direction &= 0x0F; 			                         // removing upper nibbel as it is not needed
	PortARestore = PORTA; 			                     // reading the PORTA's original status
	PortARestore &= 0xF0; 			                     // setting lower direction nibbel to 0
	PortARestore |= Direction; 	                         // adding lower nibbel for direction command and restoring the PORTA status
	PORTA = PortARestore;
	sharp = ADC_Conversion(11);						     //Stores the Analog value of front sharp connected to ADC channel 11 into variable "sharp"
	value = Sharp_GP2D12_estimation(sharp);				 //Stores Distance calsulated in a variable "value".
	if(value<200)
		{
			PORTA=0x00;
			f=0;
			buzzer_on();
			_delay_ms(1000);
			buzzer_off();
			return f;
		}
		return f;	                                      // setting the command to the port
}
//Function used for setting motor's direction
int motion_set1 (unsigned char Direction)
{
	int f=1;
	unsigned char PortARestore = 0;
	Direction &= 0x0F; 			                          // removing upper nibbel as it is not needed
	PortARestore = PORTA; 			                      // reading the PORTA's original status
	PortARestore &= 0xF0; 			                      // setting lower direction nibbel to 0
	PortARestore |= Direction; 	                          // adding lower nibbel for direction command and restoring the PORTA status
	PORTA = PortARestore;
	return f;	                                          // setting the command to the port
}
//function to on buzzer
void buzzer_on (void)
{
	unsigned char port_restore = 0;
	port_restore = PINC;
	port_restore = port_restore | 0x08;
	PORTC = port_restore;
}
//function to off buzzer
void buzzer_off (void)
{
	unsigned char port_restore = 0;
	port_restore = PINC;
	port_restore = port_restore & 0xF7;
	PORTC = port_restore;
}

//Function To Initialize UART0
// desired baud rate:9600
// actual baud rate:9600 (error 0.0%)
// char size: 8 bit

void uart0_init(void)
{
	UCSR0B = 0x00;               //disable while setting baud rate
	UCSR0A = 0x00;
	UCSR0C = 0x06;
	UBRR0L = 0x5F;               //set baud rate low
	UBRR0H = 0x00;               //set baud rate high
	UCSR0B = 0x98;
}

//function to take parameters passed by UART
SIGNAL(SIG_USART0_RECV) 		// ISR for receive complete interrupt
{   int x;
	data_from_udr = UDR0; 				//making copy of data_from_udr from UDR0 in 'data_from_udr' variable

	UDR0 = data_from_udr; 				//echo data_from_udr back to PC

	if(data_from_udr == 0x38)            //ASCII value of 8
	{
		 while(data_from_udr==0x38)
		{
			x=motion_set(0x06);
			x=motion_set(0x00);
			if(x==0)
			{
				break;
			}
			data_from_udr=UDR0;
			UDR0 = data_from_udr;
		}
	}


	if(data_from_udr == 0x32)                      //ASCII value of 2
	{
		motion_set1(0x09);                //back
	}

	if(data_from_udr == 0x34)                      //ASCII value of 4
	{
		motion_set1(0x05);                //left
	}

	if(data_from_udr == 0x36)                      //ASCII value of 6
	{
		motion_set1(0x0A);                //right
	}

	if(data_from_udr == 0x35)                      //ASCII value of 5
	{
		motion_set1(0x00);                //stop
	}

	if(data_from_udr == 0x37)                     //ASCII value of 7
	{
		buzzer_on();                      //buzzer on
	}

	if(data_from_udr == 0x39)                     //ASCII value of 9
	{
		buzzer_off();                     //buzzer off
	}
	if(data_from_udr == 0x31)                     //ASCII value of 2
	{
		motion_set1(0x02);               //soft left
	}
	if(data_from_udr == 0x33)                     //ASCII value of 3
	{
		motion_set1(0x04);               //soft right
	}

}


//Function To Initialize all The Devices

void init_devices()
{
	cli();                             //Clears the global interrupts
	port_init();                       //Initializes all the ports
	adc_init();                        //initialize ADC port
	uart0_init();                      //Initailize UART1 for serial communiaction
	sei();                             //Enables the global interrupts
}

//Main Function

int main(void)
{
	init_devices();
	while(1);
}



