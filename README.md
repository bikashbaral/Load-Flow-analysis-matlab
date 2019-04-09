# Load-Flow-analysis-matlab
This repository contains solution of Load Flow analysis using Iterative method(Newton Raphson Method). <br />

Below is the format of data required in input-:<br />
General Data:
No of buses (variable name ‘nbs’): 6;<br />
No of machines (variable name ‘nmc’): 2<br />

Bus data (variable name ‘bus_dat’):

| Bus no. | Bus type | Voltage(p.u.) | Angle(deg) | P generated | Q generated | P Load | Q Load |
| ------- | -------- | ------------- | ---------- | ----------- | ----------- | ------ | ------ |
| 1       | 101      | 1.00          | 0          | 0           | 0           | 0.55   | 0.13   |
| 2       | 101      | 1.00          | 0          | 0           | 0           | 0      | 0      |
| 3       | 101      | 1.00          | 0          | 0           | 0           | 0.30   | 0.18   |
| 4       | 101      | 1.00          | 0          | 0           | 0           | 0.50   | 0.05   |
| 5       | 102      | 1.03          | 0          | 0.75        | 0           | 0.30   | 0.10   |
| 6       | 103      | 1.02          | 0          | 0           | 0           | 0      | 0      |


101:P-Q Bus; 102:P-|V| Bus; \t 103:|V|-theta (or slack) Bus

|From Bus|TO Bus|Resistance r(p.u)|Reactance x(p.u.)|Line Charging B (p.u.)|Tap ratio|
|---|---|---|---|---|---|
|6|2|0.080|0.370|0.280|1.000|
|6|4|0.123|0.518|0.400|1.000|
|5|1|0.723|1.050|0.200|1.000|
|5|3|0.282|0.640|0.300|1.000|
|2|4|0.097|0.407|0.240|1.000|
|2|1|0.0|0.133|0.000|1.050|
|4|3|0.0|0.300|0.000|1.025|

Step wise code -:
* First the Ybus is computed using Branch data 
* Iterative Newton raphson method is used to find the solution of V and Thetha
* Then reactive power and active power injection is calculated at all nodes
* Reactive power generation at the P-V bus
* Sending and recieving power at each node is calculated


