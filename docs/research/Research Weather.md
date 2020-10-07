# Research Weather
We originally had the idea to query the weather data in a background service in the app, because we thought that the difference in weather between the different parts of Enschede would be concerning for accurate predictions in the future. We decided to research this hypothesis by requesting the weather data from DarkSky for the coming week, where we compare all days. 

|  Legend: (Week 3, 13 - 19 Jan 2020) | [52.2153056,6.8426607](https://www.google.com/maps/place/Enschede/@52.2153056,6.8426607,17z/data=!3m1!4b1!4m5!3m4!1s0x47b813aff5fe499b:0x5a06c2ee9c07c57b!8m2!3d52.2155868!4d6.8457908 "52.2153056,6.8426607") | [52.2206533,6.9309539](https://www.google.com/maps/place/Sleutelkamp,+Enschede/@52.2206533,6.9309539,17z/data=!3m1!4b1!4m5!3m4!1s0x47b81449ec24cffb:0xa7ab9e6c8bd80ef1!8m2!3d52.2204603!4d6.9335136 "52.2206533,6.9309539") | [52.1952205,6.8903207](https://www.google.com/maps/place/Stroinkslanden+Noord-West,+Enschede/@52.1952205,6.8903207,16z/data=!3m1!4b1!4m5!3m4!1s0x47b8148f7d7acdef:0xe1f2ce42e1a7a0cc!8m2!3d52.193521!4d6.8925066 "52.1952205,6.8903207") | [52.2410585,6.8898462](https://www.google.com/maps/place/Deppenbroek,+Enschede/@52.2410585,6.8898462,16z/data=!3m1!4b1!4m5!3m4!1s0x47b813f8af5beb5f:0x437e08be31eb4af8!8m2!3d52.2403059!4d6.8930332 "52.2410585,6.8898462") | [52.2219096,6.8917915](https://www.google.com/maps/place/Kloosterstraat+1,+7514+EZ+Enschede/@52.2219096,6.8917915,17z/data=!3m1!4b1!4m5!3m4!1s0x47b814748488adc1:0xd52f46be1309096e!8m2!3d52.2219063!4d6.8939802 "52.2219096,6.8917915") |  |  |
| --- | --- | --- | --- | --- | --- | --- | --- |
|  Red = Max, Green = Mid, Yellow = Low | West | Oost | Zuid | Noord | Midden | Percentage Difference | Amount Difference |
| --- | --- | --- | --- | --- | --- | --- | --- |
|  Current Precip Intensity | 0.0063 | 0.0067 | 0.0061 | 0.0067 | 0.0065 | 9% | 0.0006 |
|  Current Precip Probability | 0.36 | 0.36 | 0.35 | 0.36 | 0.35 | 2% | 0.01 |
|  Current Temperature | 46.77 | 46.56 | 46.7 | 46.71 | 46.68 | 0% | 0.21 |
|  Monday Precip Intensity | 0.0107 | 0.0109 | 0.0107 | 0.0109 | 0.0108 | 1% | 0.0002 |
|  Monday Precip Probability | 0.97 | 0.97 | 0.97 | 0.98 | 0.97 | 1% | 0.01 |
|  Monday Precip Intensity Max | 0.0347 | 0.0335 | 0.0337 | 0.0342 | 0.0339 | 3% | 0.0012 |
|  Monday Temperature Min | 47.91 | 47.58 | 47.78 | 47.79 | 47.75 | 0% | 0.33 |
|  Monday Temperature Max | 48.94 | 48.63 | 48.82 | 48.83 | 48.79 | 0% | 0.31 |
|  Tuesday Precip Intensity | 0.0029 | 0.003 | 0.003 | 0.003 | 0.003 | 3% | 0.0001 |
|  Tuesday Precip Probability | 0.64 | 0.64 | 0.64 | 0.64 | 0.64 | 0% | 0 |
|  Tuesday Precip Intensity Max | 0.0239 | 0.0228 | 0.0231 | 0.0235 | 0.0233 | 4% | 0.0011 |
|  Tuesday Temperature Min | 39.03 | 38.93 | 39.03 | 39.01 | 39 | 0% | 0.1 |
|  Tuesday Temperature Max | 55.72 | 55.42 | 55.71 | 55.67 | 55.66 | 0% | 0.3 |
|  Wednesday Precip Intensity | 0 | 0 | 0 | 0 | 0 | 0% | 0 |
|  Wednesday Precip Probability | 0.02 | 0.02 | 0.02 | 0.02 | 0.02 | 0% | 0 |
|  Wednesday Precip Intensity Max | 0.0004 | 0.0004 | 0.0004 | 0.0004 | 0.0004 | 0% | 0 |
|  Wednesday Temperature Min | 43.75 | 43.45 | 43.58 | 43.66 | 43.61 | 0% | 0.3 |
|  Wednesday Temperature Max | 48.91 | 48.54 | 48.79 | 48.71 | 48.69 | 0% | 0.37 |
|  Thursday Precip Intensity | 0.0049 | 0.005 | 0.0053 | 0.0047 | 0.005 | 12% | 0.0006 |
|  Thursday Precip Probability | 0.88 | 0.9 | 0.9 | 0.88 | 0.89 | 2% | 0.02 |
|  Thursday Precip Intensity Max | 0.0171 | 0.0194 | 0.0192 | 0.0174 | 0.0182 | 13% | 0.0023 |
|  Thursday Temperature Min | 37.61 | 37.59 | 37.78 | 37.55 | 37.63 | 0% | 0.23 |
|  Thursday Temperature Max | 47.87 | 47.34 | 47.59 | 47.71 | 47.62 | 1% | 0.53 |
|  Friday Precip Intensity | 0.0024 | 0.0024 | 0.0024 | 0.0024 | 0.0024 | 0% | 0 |
|  Friday Precip Probability | 0.56 | 0.55 | 0.56 | 0.55 | 0.55 | 1% | 0.01 |
|  Friday Precip Intensity Max | 0.0117 | 0.012 | 0.0116 | 0.0122 | 0.0119 | 5% | 0.0006 |
|  Friday Temperature Min | 34.45 | 34.39 | 34.53 | 34.41 | 34.45 | 0% | 0.14 |
|  Friday Temperature Max | 43.62 | 43.3 | 43.52 | 43.51 | 43.48 | 0% | 0.32 |
|  Saturday Precip Intensity | 0.0007 | 0.001 | 0.0009 | 0.0008 | 0.0009 | 42% | 0.0003 |
|  Saturday Precip Probability | 0.33 | 0.34 | 0.33 | 0.33 | 0.33 | 3% | 0.01 |
|  Saturday Precip Intensity Max | 0.0023 | 0.0038 | 0.0035 | 0.0027 | 0.0031 | 65% | 0.0015 |
|  Saturday Temperature Min | 33.77 | 33.74 | 33.79 | 33.75 | 33.76 | 0% | 0.05 |
|  Saturday Temperature Max | 42.95 | 42.58 | 42.8 | 42.83 | 42.79 | 0% | 0.37 |
|  Sunday Precip Intensity | 0.0001 | 0.0001 | 0.0001 | 0.0002 | 0.0001 | 100% | 0.0001 |
|  Sunday Precip Probability | 0.16 | 0.17 | 0.17 | 0.17 | 0.17 | 6% | 0.01 |
|  Sunday Precip Intensity Max | 0.0003 | 0.0003 | 0.0003 | 0.0004 | 0.0003 | 33% | 0.0001 |
|  Sunday Temperature Min | 32 | 31.96 | 32.02 | 31.98 | 31.99 | 0% | 0.06 |
|  Sunday Temperature Max | 40.22 | 39.9 | 40.1 | 40.1 | 40.08 | 0% | 0.32 |