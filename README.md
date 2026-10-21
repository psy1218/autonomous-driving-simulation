# Autonomous Driving Simulation

MATLAB, Simulink, RoadRunner를 사용한 차량 제어 및 자율주행 시뮬레이션 실습 자료입니다.

## 주요 내용

- Kinematic Bicycle Model 기반 차량 시뮬레이션
- Pure Pursuit 기반 경로 추종
- RoadRunner와 Simulink 연동
- 차선 및 차량 인식, 전방 센서 융합
- 종방향 및 횡방향 차량 제어
- 전진·후진 주차 경로 추종과 기어 전환

## 폴더 구성

| 경로 | 설명 |
| --- | --- |
| `vehicle_simulation_박소윤/` | Pure Pursuit와 간단한 3D 차량 시뮬레이션 |
| `RoadRunner_Simulink_박소윤/` | RoadRunner 연동 보고서와 결과 영상 |
| `roadrunner_parking/` | 주차 시나리오를 포함한 통합 프로젝트 |
| `parkingGarage/` | 주차장 RoadRunner 장면 및 시나리오 |
| `competition_rrscene_rrscenario/` | 주행 트랙 장면 및 시나리오 |
| `GenerateCodeForLaneMarkerDetectorExample6/` | 차선 검출 및 코드 생성 실습 |
| `20251107_roadrunner_scenario/` | RoadRunner 기반 시나리오 프로젝트 |

## 실행 환경

- MATLAB/Simulink
- Automated Driving Toolbox
- RoadRunner 및 관련 지원 패키지
- 일부 프로젝트는 Windows 환경을 전제로 합니다.

## 실행 시 주의사항

`roadrunner_parking/20251128_roadrunner_parking/HLFWithRRScenario/main.m` 등 일부 스크립트에는 작성 당시 PC의 RoadRunner 설치 경로와 프로젝트 경로가 들어 있습니다. 실행 전에 자신의 환경에 맞게 경로를 수정해야 합니다.

## 대용량 파일

영상, 발표자료, Simulink 모델 및 기타 바이너리 파일은 Git LFS로 관리합니다. 저장소를 받은 뒤 필요한 경우 `git lfs pull`을 실행하세요.

## 출처 안내

프로젝트 일부는 MathWorks 예제와 지원 패키지 자료를 바탕으로 작성되었습니다. 각 파일에 포함된 원 저작권 고지를 유지합니다.
