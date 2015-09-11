# Comparison and Evaluation of Suitable Ranging Technologies

## Technologies
http://www.dtic.mil/cgi-bin/GetTRDoc?Location=U2&doc=GetTRDoc.pdf&AD=ADA422844
http://repository.cmu.edu/cgi/viewcontent.cgi?article=1413&context=robotics (alt)
highly non-cientific overview http://en.wikipedia.org/wiki/Indoor_positioning_system

- Interial
* Time of Flight
	* http://robotics.eecs.berkeley.edu/~pister/publications/2006/Lanzisera%20RF%20TOF.pdf
  * Electro-Magnetic
	* Sonar
* Signal Strength
* External Tracking
* Phase-Difference-Measurement

## Existing Hardware
- Inertial Something
  * Optical Flow
	* Image Processing
* Cricket http://ahvaz.ist.unomaha.edu/azad/temp/sac/05-priyantha-localization-sensor-networks-coverage-thesis-good.pdf
	* Collision with Sonar Sensors, Medium Access
	* http://www.researchgate.net/profile/Linghui_Yang/publication/270126991_A_highly_accurate_ultrasonic_ranging_method_based_on_onset_extraction_and_phase_shift_detection/links/54e74f600cf2cd2e0292f3fc.pdf
* Active Bat
	* https://www.cl.cam.ac.uk/research/dtg/attarchive/bat/
	* 720 receivers to cover an area of around 1000m2 on three floors. The system can determine the positions of up to 75 objects each second, accurate to around 3cm in three dimensions.
* Indoor Time-Of-Flight-Ranging
	* http://conferences2.sigcomm.org/co-next/2014/CoNEXT_papers/p13.pdf
	* http://robotics.eecs.berkeley.edu/~pister/290Q/Papers/Location/Lanzisera%20RF%20TOF%20WISES06.pdf
* Indoor-GPS 
  * IGPS http://porto.polito.it/2438175/2/IJAMT_iGPS_and_LT.pdf
  	* Angular measurement -> No ranging
	* http://www.researchgate.net/profile/Bardia_Alavi/publication/224315086_Measurement_and_Modeling_of_Ultrawideband_TOA-Based_Ranging_in_Indoor_Multipath_Environments/links/0912f50b396c340971000000.pdf
  * Clock-Accuracy -> Price
* RSSI-Based Ranging
  * BT-RSSI based Ranging
	  * accuracy ~1.5m http://tam.unige.ch/assets/documents/masters/bekkelien/Bekkelien_Master_Thesis.pdf
	* RFID-RSSI based
  * http://www.gnss.com.au/JoGPS/v9n2/JoGPS_v9n2p122-130.pdf (kombinierter BT/WIFI ranging, fingerprinting – angelernte map)
* AtmelRTB
  * http://www.metirionic.com/en/technology.html
	* AT86RF233
	* https://www.dresden-elektronik.de/funktechnik/produkte/boards-und-kits/development-kits/devkit-positioning/?L=0
	* SAM3
* DecaWave http://www.decawave.com/products/trek1000

## Additional Sources
* AR-Drone: http://cas.ensmp.fr/~petit/papers/ifac11/PJB.pdf
* Overview: https://www1.ethz.ch/igp/geometh/people/rmautz/mautz_darmstadt09.pdf

