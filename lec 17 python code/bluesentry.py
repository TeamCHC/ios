#this is a comment
import matplotlib.pyplot as plt
#import pdb

MAX_INT = float(pow(2,16));
VOLTAGE = 5.0
SLOPE   = 25.0
OFFSET  = -12.5

# We have 4 ADC channel data in an ascii text file
# every four letters represent one ADC value
# in hexadecimal, and there are four values in each line of the file
# the first six bytes are not used in each line
# an example looks like this:
#  -0009 24C3 206F 41EF 6A80


def convert_adc_value(string_value):
    ''' 
        Convert a string into a value
        Use ADC voltage and sensor value to convert
        voltage
    '''
    int_value = int("0x" + string_value,0);
    return int_value / MAX_INT*VOLTAGE*SLOPE+OFFSET

adc1 = [];
adc2 = [];
adc3 = [];
adc4 = [];

#pdb.set_trace()

with open("ADC_data.txt") as f:
    for line in f:
        adc1.append( convert_adc_value(line[6:10])  )
        adc2.append( convert_adc_value(line[11:15]) )
        adc3.append( convert_adc_value(line[16:20]) )
        adc4.append( convert_adc_value(line[21:25]) )

plt.plot(adc1)
plt.plot(adc2)
plt.plot(adc3)
plt.plot(adc4)
plt.show()


