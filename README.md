# installGeant
# Script for automatically downloading and installing GEANT (including required libraries and setting up environment)

# For QT creator CMake compilation run CMake with
-DGeant4_DIR=/opt/geant4.10.03.p01/geant-install/lib/Geant4-10.3.1

# For usage with QT creator, add following to build enviroment (Batch edit)
G4ABLADATA=/opt/geant4.10.03.p01/geant-install/share/Geant4-10.3.1/data/G4ABLA3.0
G4ENSDFSTATEDATA=/opt/geant4.10.03.p01/geant-install/share/Geant4-10.3.1/data/G4ENSDFSTATE2.1
G4LEDATA=/opt/geant4.10.03.p01/geant-install/share/Geant4-10.3.1/data/G4EMLOW6.50
G4LEVELGAMMADATA=/opt/geant4.10.03.p01/geant-install/share/Geant4-10.3.1/data/PhotonEvaporation4.3.2
G4NEUTRONHPDATA=/opt/geant4.10.03.p01/geant-install/share/Geant4-10.3.1/data/G4NDL4.5
G4NEUTRONXSDATA=/opt/geant4.10.03.p01/geant-install/share/Geant4-10.3.1/data/G4NEUTRONXS1.4
G4PIIDATA=/opt/geant4.10.03.p01/geant-install/share/Geant4-10.3.1/data/G4PII1.3
G4RADIOACTIVEDATA=/opt/geant4.10.03.p01/geant-install/share/Geant4-10.3.1/data/RadioactiveDecay5.1.1
G4REALSURFACEDATA=/opt/geant4.10.03.p01/geant-install/share/Geant4-10.3.1/data/RealSurface1.0
G4SAIDXSDATA=/opt/geant4.10.03.p01/geant-install/share/Geant4-10.3.1/data/G4SAIDDATA1.1
LD_LIBRARY_PATH=/opt/geant4.10.03.p01/geant-install/lib
PATH=/opt/geant4.10.03.p01/geant-install/bin:${PATH}
