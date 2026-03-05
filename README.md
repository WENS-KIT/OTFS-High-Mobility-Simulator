![Logo_for_Git](https://github.com/WENS-KIT/Altitude-based-Automatic-Tiling-Algorithm-for-Small-Object-Detection/assets/96454461/c66d7644-a9b7-4d77-a0db-46105f4b0aaa)
<!-- change the link of the logo which on your repo. -->

## The [WENS](https://sites.google.com/view/wenslab/home?authuser=0) is a  Wireless and Emerging Network System Laboratory at the [Kumoh National Institute of Technology](https://eng.kumoh.ac.kr/) in the Republic of Korea (South Korea). 

### Our research interests include signal processing, algorithm, protocol, and application of the wireless network & communication. Such as 
* Radio access technologies (RAT) for Beyond B5G/6G and Future Radio Access
* Unmanned Every Vehicle (UxV) such UAV, UGV, UUV, USV 
* Artificial Intelligence, Deep Learning  
* Augmented reality, Mixed reality 
* Embedded System / Internet of Things
* Wearable device & computing
* Wired/wireless network application   
### but not limited.

### <!-- Note here the introduce of the repo or docker image. -->

# NOMA Simulator

We are happy to announce the release of the NOMA Downlink System Level Simulator source Code.
You can download the matlab file given above.

To get access to the download link simulator, please send an e-mail to WENS Laboratory (labwens@gmail.com) including:

1) Identity (name, date of birth, e-mail, phone number, address, and institution)

2) The reason/purpose for using the NOMA Simulator.

The features of thie simulator are listed below. You can also check the list of features and the documentation of the new version on the webpage of the corresponding simulator. You can download our paper regarding NOMA simulator from the link given below.

You are welcome to post your questions/comments/feedback to the WENS Laboratory (labwens@gmail.com). Our team will try to support you as soon as possible. Please also read the license agreement carefully to check whether you would need our permission to use the simulator.

Best regards,
The NOMA Simulator Team.


# Published article 

Khan, A.; Usman, M.A.; Usman, M.R.; Ahmad, M.; Shin, S.-Y. Link and System-Level NOMA Simulator: The Reproducibility of Research. Electronics 2021, 10, 2388. 
https://doi.org/10.3390/electronics10192388

# Cite this article as:

@article{2021, title={Link and System-Level NOMA Simulator: The Reproducibility of Research}, 
volume={10}, ISSN={2079-9292}, DOI={10.3390/electronics10192388}, number={19}, journal={Electronics}, publisher={MDPI AG}, 
author={Khan, Arsla and Usman, Muhammad Arslan and Usman, Muhammad Rehan and Ahmad, Muneeb and Shin, Soo-Young}, 
year={2021}, month={Sep}, pages={2388}, url={http://dx.doi.org/10.3390/electronics10192388}}

# Abstarct

This study focuses on the design of a MATLAB platform for non-orthogonal multiple access (NOMA) based systems with link-level and system-level analyses. Among the different potential candidates for 5G, NOMA is gaining considerable attention owing to the many-fold increase in spectral efficiency as compared to orthogonal multiple access (OMA). In this study, a NOMA simulator is presented for two and more than two users in a single cell for link-level analysis; whereas, for system-level analysis, seven cells and 19 cells scenarios were considered. Long-term evolution (LTE) was used as the baseline for the NOMA simulator, while bit error rate (BER), throughput and spectral efficiency are used as performance metrics to analyze the simulator performance. Moreover, we demonstrated the application of the NOMA simulator for different simulation scenarios through examples. In addition, the performance of multi-carrier NOMA (MC-NOMA) was evaluated in the presence of AWGN, impulse noise, and intercell interference. To circumvent channel impairments, channel coding with linear precoding is suggested to improve the BER performance of the system.

# About this code

The parameters in the code file are given below:
<!-- ===================== Simulation Parameters (Styled Table) ===================== -->
<table style="width:100%; border-collapse:separate; border-spacing:0; overflow:hidden; border:1px solid #cfd8dc; border-radius:10px; font-family:Arial, sans-serif;">
  <tr>
    <th colspan="2" style="background:#1e4d7b; color:#ffffff; text-align:center; padding:10px; font-size:18px; letter-spacing:0.2px;">
      General Parameters
    </th>
  </tr>
  <tr>
    <th style="background:#dfe8c8; color:#1b1b1b; text-align:center; padding:8px; width:55%; border-top:1px solid #cfd8dc;">
      Parameters
    </th>
    <th style="background:#dcecf9; color:#1b1b1b; text-align:center; padding:8px; width:45%; border-top:1px solid #cfd8dc;">
      Value
    </th>
  </tr>

  <tr>
    <td style="background:#dfe8c8; padding:7px 10px; border-top:1px solid #e5e7eb;">Delay Resources (M)</td>
    <td style="background:#dcecf9; padding:7px 10px; border-top:1px solid #e5e7eb; text-align:center;">[8, 16, 32, 64]</td>
  </tr>
  <tr>
    <td style="background:#dfe8c8; padding:7px 10px; border-top:1px solid #e5e7eb;">Doppler Resources (N)</td>
    <td style="background:#dcecf9; padding:7px 10px; border-top:1px solid #e5e7eb; text-align:center;">[8, 16, 32, 64]</td>
  </tr>
  <tr>
    <td style="background:#dfe8c8; padding:7px 10px; border-top:1px solid #e5e7eb;">Carrier Frequency</td>
    <td style="background:#dcecf9; padding:7px 10px; border-top:1px solid #e5e7eb; text-align:center;">5&nbsp;GHz</td>
  </tr>
  <tr>
    <td style="background:#dfe8c8; padding:7px 10px; border-top:1px solid #e5e7eb;">Max Speed (v)</td>
    <td style="background:#dcecf9; padding:7px 10px; border-top:1px solid #e5e7eb; text-align:center;">0–1000&nbsp;km/h</td>
  </tr>
  <tr>
    <td style="background:#dfe8c8; padding:7px 10px; border-top:1px solid #e5e7eb;">Doppler Shift</td>
    <td style="background:#dcecf9; padding:7px 10px; border-top:1px solid #e5e7eb; text-align:center;">Jakes Spectrum</td>
  </tr>
  <tr>
    <td style="background:#dfe8c8; padding:7px 10px; border-top:1px solid #e5e7eb;">Modulation Order (Q)</td>
    <td style="background:#dcecf9; padding:7px 10px; border-top:1px solid #e5e7eb; text-align:center;">[2, 4, 8, 16]</td>
  </tr>
  <tr>
    <td style="background:#dfe8c8; padding:7px 10px; border-top:1px solid #e5e7eb;">Modulation Type</td>
    <td style="background:#dcecf9; padding:7px 10px; border-top:1px solid #e5e7eb; text-align:center;">PSK, QAM</td>
  </tr>
  <tr>
    <td style="background:#dfe8c8; padding:7px 10px; border-top:1px solid #e5e7eb;">Channel Propagation Models</td>
    <td style="background:#dcecf9; padding:7px 10px; border-top:1px solid #e5e7eb; text-align:center;">3GPP (TDL-A, TDL-B, TDL-C)</td>
  </tr>

  <tr>
    <th colspan="2" style="background:#1e4d7b; color:#ffffff; text-align:center; padding:10px; font-size:18px; border-top:2px solid #ffffff;">
      Index Modulation Parameters
    </th>
  </tr>
  <tr>
    <td style="background:#dfe8c8; padding:7px 10px; border-top:1px solid #e5e7eb;">DDRB’s Per Group (n)</td>
    <td style="background:#dcecf9; padding:7px 10px; border-top:1px solid #e5e7eb; text-align:center;">4</td>
  </tr>
  <tr>
    <td style="background:#dfe8c8; padding:7px 10px; border-top:1px solid #e5e7eb;">Active DDRB’s Per Group (k)</td>
    <td style="background:#dcecf9; padding:7px 10px; border-top:1px solid #e5e7eb; text-align:center;">[1, 2, 3]</td>
  </tr>
  <tr>
    <td style="background:#dfe8c8; padding:7px 10px; border-top:1px solid #e5e7eb;">Performance Parameters</td>
    <td style="background:#dcecf9; padding:7px 10px; border-top:1px solid #e5e7eb; text-align:center;">BER, BPCU</td>
  </tr>
  <tr>
    <td style="background:#dfe8c8; padding:7px 10px; border-top:1px solid #e5e7eb;">Performance Comparison</td>
    <td style="background:#dcecf9; padding:7px 10px; border-top:1px solid #e5e7eb; text-align:center;">OFDM-IM, OTFS</td>
  </tr>

  <tr>
    <th colspan="2" style="background:#1e4d7b; color:#ffffff; text-align:center; padding:10px; font-size:18px; border-top:2px solid #ffffff;">
      NOMA Parameters
    </th>
  </tr>
  <tr>
    <td style="background:#dfe8c8; padding:7px 10px; border-top:1px solid #e5e7eb;">Network Setup</td>
    <td style="background:#dcecf9; padding:7px 10px; border-top:1px solid #e5e7eb; text-align:center;">Downlink with Perfect CSI</td>
  </tr>
  <tr>
    <td style="background:#dfe8c8; padding:7px 10px; border-top:1px solid #e5e7eb;">Interference Cancellation</td>
    <td style="background:#dcecf9; padding:7px 10px; border-top:1px solid #e5e7eb; text-align:center;">Perfect SIC</td>
  </tr>
  <tr>
    <td style="background:#dfe8c8; padding:7px 10px; border-top:1px solid #e5e7eb;">Power Allocation</td>
    <td style="background:#dcecf9; padding:7px 10px; border-top:1px solid #e5e7eb; text-align:center;">Fixed Power</td>
  </tr>
  <tr>
    <td style="background:#dfe8c8; padding:7px 10px; border-top:1px solid #e5e7eb;">Number of Tx/Rx Antenna</td>
    <td style="background:#dcecf9; padding:7px 10px; border-top:1px solid #e5e7eb; text-align:center;">Single Antenna</td>
  </tr>
  <tr>
    <td style="background:#dfe8c8; padding:7px 10px; border-top:1px solid #e5e7eb;">Performance Comparison</td>
    <td style="background:#dcecf9; padding:7px 10px; border-top:1px solid #e5e7eb; text-align:center;">OTFS/OFDM (NOMA, OMA)</td>
  </tr>
  <tr>
    <td style="background:#dfe8c8; padding:7px 10px; border-top:1px solid #e5e7eb;">Performance Parameters</td>
    <td style="background:#dcecf9; padding:7px 10px; border-top:1px solid #e5e7eb; text-align:center;">BER, Throughput</td>
  </tr>

  <tr>
    <th colspan="2" style="background:#1e4d7b; color:#ffffff; text-align:center; padding:10px; font-size:18px; border-top:2px solid #ffffff;">
      MIMO Parameters
    </th>
  </tr>
  <tr>
    <td style="background:#dfe8c8; padding:7px 10px; border-top:1px solid #e5e7eb;">Number of Tx/Rx Antenna</td>
    <td style="background:#dcecf9; padding:7px 10px; border-top:1px solid #e5e7eb; text-align:center;">[1, 2, 3]</td>
  </tr>
  <tr>
    <td style="background:#dfe8c8; padding:7px 10px; border-top:1px solid #e5e7eb;">MIMO Mode</td>
    <td style="background:#dcecf9; padding:7px 10px; border-top:1px solid #e5e7eb; text-align:center;">Spatial Multiplexing, Spatial Diversity</td>
  </tr>
  <tr>
    <td style="background:#dfe8c8; padding:7px 10px; border-top:1px solid #e5e7eb;">Performance Parameters</td>
    <td style="background:#dcecf9; padding:7px 10px; border-top:1px solid #e5e7eb; text-align:center;">BER, Throughput</td>
  </tr>
  <tr>
    <td style="background:#dfe8c8; padding:7px 10px;">Performance Comparison</td>
    <td style="background:#dcecf9; padding:7px 10px; text-align:center;">MIMO OFDM, MIMO AFDM, MIMO OCDM</td>
  </tr>
</table>
<!-- ============================================================================ -->

|# Parameters          |           # OMA                               |            # NOMA                  |
|----------------------|-----------------------------------------------|------------------------------------|
|System Level	         |           Downlink	                           |            Downlink                |
|Random User	         |           2 users	                           |              2 users               |
|Multi-cell	           |        3;7;19 cells	                         |            3;7;19 cells            |
|Frequency	           |       900;1800;2100;2600 MHz	                 |       900;1800;2100;2600 MHz       |
|Propagation Model	   |       Okumura-Hata;Cost-231	                 |         Okumura-Hata;Cost-231      |
|Imperfect SIC	       |               N/A	                           |                  ✔                 |
|Interference	         | Intercell interference;SINR	                 |   Intercell Interference;SINR      |
|Cell Capacity       	 |User capacity;Ergodic sum capacity	           |User capacity;Ergodic sum capacity  |

# Software 
Matlab R20b or above

Please download the related Runtime installer if you encounter .dll error.

# Reference Papers


# OTFS-High-Mobility-Simulator
High-Mobility OTFS Link-Level Simulator for delay-Doppler channels, including OTFS-IM, MIMO-OTFS, and NOMA-OTFS, with BER/BPCU/throughput benchmarking and baseline comparisons.

This repository provides a high-mobility OTFS link-level simulation framework designed to study performance in delay-Doppler selective channels under realistic mobility effects. 
It includes dedicated packages for OTFS with Index Modulation (OTFS-IM), MIMO-OTFS, and NOMA-OTFS, and supports configurable delay/doppler resource grids, PSK/QAM constellations, Jakes-spectrum Doppler, 
and 3GPP TDL channel models. The simulator reports standard metrics such as BER, BPCU, and throughput, and enables direct performance comparisons against relevant baselines.
