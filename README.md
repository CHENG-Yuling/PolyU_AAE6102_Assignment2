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


- `postProcessing.m`
<img src=https://github.com/CHENG-Yuling/PolyU_AAE6102_Assignment2 alt="替代文本" width=400 height=300>


<img src=https://github.com/CHENG-Yuling/PolyU_AAE6102_Assignment2 alt="替代文本" width=400 height=300>


### Task 3 ###
1. Weighted Least Squares (WLS) Implementation
In WLS, the weight of the error is considered and the following formula is used for parameter estimation: $\hat{\mathbf{p}} = (\mathbf{H}^T \mathbf{W} \mathbf{H})^{-1} \mathbf{H}^T \mathbf{W} \mathbf{r}$。

2. Weighted RAIM Algorithm
a. Input Data
Load the provided "Open-Sky" data, which includes pseudorange measurements from multiple satellites.

b. Compute the Position Estimate
Use your WLS implementation to compute the position estimate 
𝑥


### Task 4 ###
```bash
Model: ChatGPT 4.1
Chatroom Link: https://poe.com/s/MFzPZuzLZXcqX1yD6yOX
```

### Task 5 ###
```bash
Model: ChatGPT 4.1
Chatroom Link: https://poe.com/s/MFzPZuzLZXcqX1yD6yOX
```
