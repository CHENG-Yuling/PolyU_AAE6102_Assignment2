# PolyU_AAE6102_Assignment2

**Author:** CHENG Yuling  
**Student ID:** 24041314r 

### Task 1 ###
```bash
Model: ChatGPT 4.1
Chatroom Link: https://poe.com/s/OsaUnRpRIZHnOj54nKPv
```
#### 1. Differential GNSS (DGNSS): ####
Uses correction data from reference stations at known locations to improve accuracy over standard GNSS.

**Pros:**
   - Improved Accuracy: Typically improves position accuracy to 1–3 meters (vs. ~5–10 meters for standalone GNSS).
   - Relatively Simple: Easier to implement than RTK or PPP, especially for consumer devices.
   - Widely Supported: Many existing infrastructure and services provide DGNSS corrections.

**Cons:**
   - Limited Accuracy: Still not sufficient for lane-level navigation (sub-meter accuracy).
   - Coverage Limitations: Correction quality degrades with distance from the reference station.
   - Latency: Corrections may not be real-time in all cases (depends on delivery method).
   - Smartphone Constraints: Most smartphones have limited support for external correction input.

#### 2. Real-Time Kinematic (RTK) ####

Uses carrier phase measurements and real-time corrections from a nearby base station to achieve centimeter-level accuracy.

**Pros:**
   - High Accuracy: Can achieve centimeter-level positioning, suitable for applications requiring very precise location (e.g., survey, autonomous vehicles).
   - Real-Time: Provides immediate corrections for high-precision tasks.

**Cons:**
   - Infrastructure Needs: Requires access to a nearby base station or a network of stations.
   - Short Baseline Requirement: Accuracy drops rapidly beyond 10–20 km from the base station.
   - Complexity: More complicated to implement and maintain than DGNSS.
   - Smartphone Limitations: Most phones lack the raw carrier phase output and stable antennas needed for reliable RTK.
   - Power and Data Usage: Increases battery drain and requires a steady data connection for corrections.

#### 3. Precise Point Positioning (PPP) ####
Uses precise satellite orbit/clock data and advanced algorithms to improve accuracy without needing local reference stations.

**Pros:**
   - Global Coverage: Works anywhere with a view of the sky, no need for local base stations.
   - Improved Accuracy: Achieves sub-meter to decimeter-level accuracy.
   - No Local Infrastructure: Only requires access to precise correction data, often via the internet.

**Cons:**
   - Convergence Time: Can take several minutes to reach full accuracy after startup.
   - Lower Than RTK: May not reach centimeter-level accuracy.
   - Data Needs: Requires reception of precise correction data, which may not be free.
   - Smartphone Hardware: Limited by smartphone antenna and hardware quality.

#### 4. PPP-RTK ####

Combines PPP and RTK, using global corrections plus local biases, to achieve both fast convergence and high accuracy.

**Pros:**
   - Rapid Convergence: Achieves high accuracy in under a minute, faster than PPP alone.
   - High Accuracy: Centimeter to decimeter-level accuracy.
   - Scalable: Provides benefits of both PPP (global) and RTK (local) corrections.
   - No Need for Close Base: Less dependent on proximity to a local base station.

**Cons:**
   - Complexity: More complex algorithm and correction data required.
   - Data Requirements: Needs precise satellite data plus local bias corrections.
   - Infrastructure: Needs a dense reference station network for best results.
   - Smartphone Limitations: Few smartphones support the required raw data and stable antenna performance
   
| Technique   | Working Principle                     | Accuracy     | Coverage   | Robustness | Infra. & Cost | Limitations                          | Typical Use                  |
|-------------|---------------------------------------|--------------|------------|------------|----------------|--------------------------------------|------------------------------|
| **DGNSS**   | Regional code corrections             | 1–3 m       | Regional   | Good       | Moderate       | Limited precision, coverage          | Navigation, agriculture      |
| **RTK**     | Local carrier-phase + base            | 1–5 cm      | Local      | Medium     | High           | Short range, cost, hardware         | Survey, construction         |
| **PPP**     | Global precise corrections             | 10–50 cm    | Global     | Medium     | Moderate       | Slow start, hardware limits          | Research, mapping            |
| **PPP-RTK** | PPP + local biases                    | 2–10 cm     | Wide-area  | High       | Highest        | Complex, costly, limited             | Autonomous, pro surveying    |


**In summary:**
DGNSS is affordable and practical, but not highly precise. RTK and PPP-RTK deliver the best accuracy, but require infrastructure and are currently impractical for most smartphones. PPP provides a good balance for some advanced smartphone applications, especially as hardware and correction services improve. Smartphone adoption of advanced techniques will depend on evolving hardware, open APIs, and affordable correction services.



### Task 2 ###

Call the - `navSolutionResults.mat` file from "Urban.dat" data generated in A1 to get the information of pseudorange, satellite position, etc.

Analyze the skymask to identify the azimuth and elevation angles where satellite signals are obstructed. After load skymask CSV, we can see the skymask is plotted with azimuth on the x-axis and blocking elevation on the y-axis.

<img src=https://github.com/CHENG-Yuling/PolyU_AAE6102_Assignment2/blob/main/Task2/Skymask%20horizon.jpg alt="替代文本" width=500 height=350>

Then process the skymask data to adjust the angle, finally obtain it:

<img src=https://github.com/CHENG-Yuling/PolyU_AAE6102_Assignment2/blob/main/Task2/GNSS%20Positioning%20in%20Urban%20Environment.jpg alt="替代文本" width=500 height=350>


### Task 3 ###
**1. Weighted Least Squares (WLS) Implementation**

In WLS, the weight of the error is considered and the following formula is used for parameter estimation: $\hat{\mathbf{p}} = (\mathbf{H}^T \mathbf{W} \mathbf{H})^{-1} \mathbf{H}^T \mathbf{W} \mathbf{r}$。

**2. Weighted RAIM Algorithm**

a. Input Data: Load the provided "Opensky.bin" data, which includes pseudorange measurements from multiple satellites.

b. Compute Residuals: After computing the position using WLS, calculate the residuals for each satellite measurement: $$\mathbf{r} = \mathbf{y} - \mathbf{A} \mathbf{x}$$

c. Compute Test Statistic: Use residuals to compute test statistics: $$T_i = \frac{r_i}{\sigma_i}$$

d. Detection Threshold: Set a detection threshold based on the probability of false alarm $$P_{fa}$$ and missed detection $$P_{md}$$. Use the hint provided:
- For $$P_{fa} = 10^{-2}$$, calculate the threshold using statistical tables or simulations.
- For $$P_{md} = 10^{-7}$$, use the threshold 5.33σ

e. Fault Detection: Compare each test statistic $$T_i$$ against the threshold. If $$T_i$$ exceeds the threshold, the measurement is considered faulty.

f. Fault Exclusion: Exclude the faulty measurement and recompute the position using the remaining measurements.

**3. Compute 3D Protection Level (PL)**

a. Protection Level Calculation: The protection level is a measure of the maximum error that can be tolerated without compromising integrity. It can be computed using the geometry of the satellite constellation and the measurement error model.

b. Use the given probabilities: 
- For $$P_{fa} = 10^{-2}$$, compute the PL using statistical methods.
- For $$P_{md} = 10^{-7}$$, ensure the PL accounts for the threshold 5.33σ.

**4. Stanford Chart Analysis**

a. Plot Stanford Chart: A Stanford Chart is used to visualize the integrity performance of the GNSS system. It plots the protection level against the actual error.

b. Evaluate Performance: Compare the computed protection level against the alarm limit (AL) of 50 meters. If the protection level exceeds the alarm limit, the system is not reliable.

<img src=https://github.com/CHENG-Yuling/PolyU_AAE6102_Assignment2/blob/main/Task3/Satellite%20Positions%20Across%20All%20Epochs.jpg alt="替代文本" width=500 height=350>

### Task 4 ###
```bash
Model: ChatGPT 4.1
Chatroom Link: https://poe.com/s/LLkzWUNAURsDwei8cyyY
```
**The Difficulties and Challenges of Using LEO Communication Satellites for GNSS Navigation**

Low Earth Orbit (LEO) satellites, typically positioned at altitudes between 160 and 2,000 kilometers above Earth’s surface, have become an essential part of modern communication infrastructure. From providing high-speed internet to remote regions via constellations like SpaceX's Starlink and OneWeb, to supporting Earth observation and scientific missions, their utility is undeniable. However, leveraging LEO communication satellites as a backbone for Global Navigation Satellite System (GNSS) services introduces a unique set of technical, operational, and economic challenges. While the concept is attractive—offering potential benefits such as stronger signals and lower latency—the difficulties in adapting LEO communication satellites for precision positioning are significant.

**1. Satellite Motion and Handovers**

One of the most fundamental differences between LEO and traditional GNSS satellites lies in their speed and orbital characteristics. LEO satellites complete an orbit in roughly 90 to 120 minutes, zipping across the sky at velocities of about 7–8 km/s relative to the ground. As a result, any given LEO satellite is visible to a ground receiver for only a brief window—typically 5 to 15 minutes—before it dips below the horizon. This rapid movement requires navigation receivers to continually acquire, track, and switch between satellites, a process known as handover. In contrast, GNSS satellites in Medium Earth Orbit (MEO) move much more slowly from the ground's perspective, allowing for longer, more stable signal acquisition and tracking. The need for frequent handovers in LEO-based navigation imposes significant demands on both receiver hardware and software, increasing complexity, power consumption, and the risk of data loss during transitions.

**2. Limited Simultaneous Coverage**

Due to their lower altitude, LEO satellites "see" a much smaller portion of Earth's surface at any given time compared to MEO satellites. To ensure continuous, global, and redundant coverage necessary for GNSS navigation, a LEO system would require a far larger constellation—potentially numbering in the thousands. By contrast, the U.S. GPS system achieves near-global coverage with just 24 to 32 satellites. The operational and financial challenges of maintaining such a massive LEO constellation, including frequent satellite replenishment due to shorter lifespans, are non-trivial.

**3. Doppler Effects**

The high relative velocities of LEO satellites introduce substantial Doppler shifts in the signals received on the ground. Unlike MEO-based GNSS signals, where Doppler correction is manageable and relatively stable, LEO signals can experience frequency shifts of several kilohertz, changing rapidly as satellites move toward or away from the receiver. Receivers intended for navigation must therefore employ sophisticated algorithms to continually estimate and correct for these shifts, increasing computational demands and potentially impacting accuracy—particularly for real-time applications.

**4. Signal Blockage and Multipath Issues**
   
Because LEO satellites transit closer to the horizon more frequently, their signals are more susceptible to blockage by terrain, buildings, and vegetation. Urban canyons and mountainous regions can create frequent outages, as the lower elevation angles at which LEO satellites are observed make them more vulnerable to obstructions. Additionally, the increased likelihood of multipath effects—where signals reflect off surfaces before reaching the receiver—can further degrade positioning accuracy.

**5. Signal Structure and Synchronization**

Most LEO communication satellites are not designed with navigation in mind. Their signals, optimized for data throughput and communication efficiency, typically lack the precisely time-stamped, spread-spectrum codes used in GNSS for accurate ranging and resilience against interference. Furthermore, these satellites often do not carry high-precision atomic clocks, making it difficult to synchronize signals to the nanosecond accuracy required for precise positioning. For true GNSS functionality, satellites must be tightly synchronized to a common time reference and their orbits must be known with high precision—requirements that are not typically met by commercial LEO constellations.

**6. Interference, Spectrum Management, and Security**
   
The radio spectrum used by LEO communication satellites is often shared with other communication services, increasing the risk of interference. Unlike dedicated GNSS frequencies, which are internationally protected and standardized, communication bands may be subject to congestion and overlapping transmissions, potentially degrading signal quality for navigation. Moreover, many LEO satellites are privately owned; their operational priorities may not align with the stringent reliability and security standards needed for navigation, especially for safety-critical or military applications. This also raises concerns regarding access, sovereignty, and long-term service guarantees.

**7. Receiver Complexity and Power Requirements**

Receivers designed to utilize LEO-based navigation must be far more capable than traditional GNSS receivers. They need to simultaneously track many fast-moving satellites, perform frequent handovers, correct for large Doppler shifts, and potentially process diverse, non-standardized signal structures. This increased complexity translates to higher power consumption—a significant drawback for mobile and battery-powered devices.

**8. Satellite Lifespan and Maintenance**

LEO satellites, due to their proximity to the upper atmosphere, are more susceptible to drag and radiation, leading to operational lifespans of only 5–10 years. As a result, maintaining a dense, global constellation for navigation would require regular launches and replacements—a logistical and financial challenge far beyond that faced by MEO-based GNSS systems, whose satellites often last 15 years or more.


| Challenge                     | Description                                                                                     |
|-------------------------------|-------------------------------------------------------------------------------------------------|
| **Rapid Handover**            | Short visibility; frequent switching between satellites can lead to interruptions in service.   |
| **Limited Coverage per Satellite** | A large constellation is required to ensure continuous coverage across the globe.            |
| **Doppler Shift**             | Large, fast frequency changes necessitate correction to maintain accurate positioning.          |
| **Shorter Lifespan**          | Satellites have a limited operational lifespan, requiring more frequent replacements.           |
| **Signal Blockage**           | GNSS signals can be easily obstructed by terrain and structures, affecting reliability.        |
| **Signal Structure**          | Current signals may not be optimized for navigation, potentially lacking robustness and openness. |
| **Timing/Position Reference** | Some systems may lack precise clocks and global coordination, impacting accuracy.               |
| **Interference**              | Shared frequency bands increase the risk of signal interference from other sources.            |
| **Receiver Complexity**       | Higher demands on tracking and processing capabilities can complicate receiver design.         |
| **Regulatory/Security**       | Issues related to private ownership raise concerns about reliability and access to GNSS services. |

In conclusion, while LEO communication satellites offer intriguing possibilities for augmenting or enhancing global navigation, particularly in delivering additional signals or improving robustness against spoofing and jamming, repurposing them as a primary means of GNSS navigation is fraught with difficulties. These challenges span technical, operational, and regulatory domains, encompassing rapid satellite motion, limited coverage, large Doppler shifts, signal vulnerability, and the lack of appropriate timing and signal structures. Overcoming these hurdles would require significant advances in satellite technology, receiver design, and international collaboration. Until then, traditional GNSS systems in higher orbits, possibly complemented by LEO-derived signals, will remain the cornerstone of global satellite navigation.

### Task 5 ###
```bash
Model: ChatGPT 4.1
Chatroom Link: https://poe.com/s/IRYpw964NK6xBoqL53ey
```

**The Impact of GNSS in Remote Sensing: A Focus on GNSS Seismology**

Global Navigation Satellite Systems (GNSS), including well-known constellations such as GPS, GLONASS, Galileo, and BeiDou, are often associated with positioning, navigation, and timing (PNT) applications. However, over the past two decades, GNSS has emerged as a powerful tool in remote sensing, revolutionizing how we observe and understand Earth's dynamic processes. Among its most transformative applications is GNSS seismology—the use of GNSS technologies to detect, monitor, and analyze ground motions caused by earthquakes and related tectonic phenomena.

**GNSS as a Remote Sensing Tool**

Remote sensing refers to the acquisition of information about an object or phenomenon without making physical contact with it. Traditionally, this field has relied on instruments such as cameras, radar, and laser altimeters. GNSS fits squarely within this definition: by analyzing the signals transmitted between satellites and ground-based receivers, scientists can remotely measure the position of those receivers with extraordinary precision. This capability has generated profound impacts in fields such as geodesy, atmospheric science, and, notably, seismology.

**The Rise of GNSS Seismology**

Seismology has long relied on seismometers to record ground shaking and infer the characteristics of earthquakes. While highly sensitive to rapid, subtle vibrations, seismometers have limitations: they measure acceleration and velocity, not displacement directly. For very large earthquakes, traditional instruments can saturate, and estimating the actual movement of the ground can be challenging.

GNSS seismology addresses these limitations by providing direct, real-time measurements of ground displacement. High-precision GNSS stations, often sampling data at 1–10 Hz, can record ground movement during and after an earthquake with accuracy down to a few millimeters. This direct measurement is especially valuable for capturing large, permanent displacements caused by powerful earthquakes or slow-slip events—movements that seismometers might miss or misestimate.

**Key Impacts on Earthquake Monitoring and Hazard Assessment**

1. **Real-Time Earthquake Characterization**  
   Perhaps the most significant impact of GNSS seismology is its contribution to rapid, accurate earthquake characterization. When a major earthquake strikes, GNSS stations near the epicenter detect the sudden ground displacement almost instantaneously. By analyzing these signals, researchers can quickly estimate the earthquake’s size (magnitude), fault slip, and rupture extent. This information is crucial for emergency response, as it informs authorities about the potential for aftershocks, infrastructure damage, and secondary hazards like landslides or tsunamis.

2. **Tsunami Early Warning**  
   GNSS seismology has proven invaluable for tsunami early warning systems. Traditional seismic data may not always distinguish between earthquakes that generate tsunamis and those that do not. Since tsunamis are caused by vertical displacement of the seafloor, GNSS receivers—especially those on coastal or offshore platforms—can directly measure this movement. This enables authorities to issue timely and accurate tsunami warnings, potentially saving thousands of lives.

3. **Slow Earthquake and Tectonic Monitoring**  
   Not all seismic activity is fast or violent. "Slow earthquakes" and "slow slip events" occur over days or weeks and are invisible to traditional seismometers. GNSS, however, can detect these subtle, gradual movements. By continuously monitoring the positions of stations across tectonic plate boundaries, scientists can study the accumulation and release of strain along faults—a critical factor in long-term earthquake hazard assessment.

**Case Studies: Real-World Impact**

A landmark example of GNSS seismology’s impact was during the 2011 Tōhoku earthquake in Japan. The country’s dense GNSS network, GEONET, recorded up to several meters of ground displacement in real time. These data allowed researchers to rapidly estimate the size and rupture area of the quake—information that was instrumental for crisis management and scientific understanding.

Similarly, GNSS networks have been deployed in earthquake-prone regions such as California, Chile, and New Zealand, where they serve not only research but also public safety missions.

**Limitations and Future Directions**

Despite its advantages, GNSS seismology faces challenges. The technology is less sensitive to small, high-frequency shaking compared to traditional seismometers, and the cost of deploying dense networks can be high. However, as GNSS receiver technology becomes more affordable and sampling rates improve, these limitations are gradually diminishing. The integration of GNSS and seismic data in "seismic-geodetic" networks is poised to provide unprecedented detail on earthquake processes.

In conclusion, GNSS seismology exemplifies the transformative impact of GNSS-based remote sensing on earth science and public safety. By enabling direct, accurate, and real-time measurements of ground displacement, GNSS has filled critical gaps left by traditional seismology, especially for large earthquakes and slow-slip events. As GNSS networks continue to expand and integrate with other sensor technologies, their role in monitoring, understanding, and mitigating seismic hazards will only grow—making GNSS seismology a cornerstone of modern remote sensing.

