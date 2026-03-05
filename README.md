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

# OTFS-High-Mobility-Simulator
High-Mobility OTFS Link-Level Simulator for delay-Doppler channels, including OTFS-IM, MIMO-OTFS, and NOMA-OTFS, with BER/BPCU/throughput benchmarking and baseline comparisons.

We are happy to announce the release of the High Mobility OTFS Link Level Simulator 

To get access to the download link, please send an e-mail to WENS Lab (labwens@gmail.com) that contains:

1- Identity (name, date of birth, e-mail, phone number, address, and institution)

2- The reason/purpose for using the OTFS Simulator.

The features are listed below. You can also check the list of features and the documentation of the new version on the webpage of the corresponding simulator.

You are welcome to post your questions/comments/feedback to the WENS Lab (labwens@gmail.com). Our team will try to support you as soon as possible. Please also read the licence agreement carefully to check whether you would need our permission to use the simulator.

Best regards,

The OTFS High Mobility Simulator Team.


# Published articles 

[1] A. Tariq, M. Sajid Sarwar and S. Y. Shin, "Orthogonal Time-Frequency–Space Multiple Access Using Index Modulation and NOMA," in IEEE Wireless Communications Letters, vol. 14, no. 5, pp. 1456-1460, May 2025, doi: 10.1109/LWC.2025.3544234.	

[2]  A. Tariq, M. S. Sarwar and S. Young Shin, "Orthogonal Time Frequency Space Index Modulation based on Non-Orthogonal Multiple Access," 2023 14th International Conference on Information and Communication Technology Convergence (ICTC), Jeju Island, Korea, Republic of, 2023, pp. 838-841, doi: 10.1109/ICTC58733.2023.10392492.

[3] A. Tariq, M.S. Sarwar and S. Y. Shin, "Orthogonal Time Frequency Space (OTFS) with Tri-Mode Index Modulation," 2024 15th International Conference on Information and Communication Technology Convergence (ICTC), Jeju Island, Korea, Republic of, 2024, pp. 1183-1186, doi: 10.1109/ICTC62082.2024.

# Cite the article as:

@ARTICLE{10897822,
  author={Tariq, Adnan and Sajid Sarwar, Muhammad and Shin, Soo Young},
  journal={IEEE Wireless Communications Letters}, 
  title={Orthogonal Time-Frequency–Space Multiple Access Using Index Modulation and NOMA}, 
  year={2025},
  volume={14},
  number={5},
  pages={1456-1460},
  keywords={Indexes;Modulation;Delays;Doppler effect;Uplink;Symbols;Time-frequency analysis;NOMA;Signal to noise ratio;Bit error rate;Index modulation;NOTFS-IMMA;OTFS-MA;OTFS-NOMA;OTFS-IM},
  doi={10.1109/LWC.2025.3544234}}

@INPROCEEDINGS{10392492,
  author={Tariq, Adnan and Sarwar, Muhammad Sajid and Young Shin, Soo},
  booktitle={2023 14th International Conference on Information and Communication Technology Convergence (ICTC)}, 
  title={Orthogonal Time Frequency Space Index Modulation based on Non-Orthogonal Multiple Access}, 
  year={2023},
  volume={},
  number={},
  pages={838-841},
  keywords={Wireless communication;Time-frequency analysis;NOMA;Spectral efficiency;Simulation;Bit error rate;Modulation;Orthogonal Time Frequency Space Index Modulation (OTFS-IM);Non-Orthogonal Multiple Access (NOMA);OTFS-IM-NOMA},
  doi={10.1109/ICTC58733.2023.10392492}}

  @INPROCEEDINGS{10827438,
  author={Tariq, Adnan and Sarwar, Muhammad Sajid and Shin, Soo Young},
  booktitle={2024 15th International Conference on Information and Communication Technology Convergence (ICTC)}, 
  title={Orthogonal Time Frequency Space (OTFS) with Tri-Mode Index Modulation}, 
  year={2024},
  volume={},
  number={},
  pages={1183-1186},
  keywords={Time-frequency analysis;Spectral efficiency;Simulation;Bit error rate;Modulation;Energy efficiency;Robustness;Information and communication technology;Indexes;Signal to noise ratio;Index modulation (IM);OTFS-IM;Tri-Mode OTFC},
  doi={10.1109/ICTC62082.2024.10827438}}

# Abstarct

This repository provides a high-mobility OTFS link-level simulation framework designed to study performance in delay-Doppler selective channels under realistic mobility effects. 
It includes dedicated packages for OTFS with Index Modulation (OTFS-IM), MIMO-OTFS, and NOMA-OTFS, and supports configurable delay/doppler resource grids, PSK/QAM constellations, Jakes-spectrum Doppler, 
and 3GPP TDL channel models. The simulator reports standard metrics such as BER, BPCU, and throughput, and enables direct performance comparisons against relevant baselines.

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

# Software 
Matlab R2024a or above

Please download the related Runtime installer if you encounter .dll error.

# Reference Papers



