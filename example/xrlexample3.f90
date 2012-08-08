!Copyright (c) 2009, 2010, 2011, 2012 Tom Schoonjans
!All rights reserved.

!Redistribution and use in source and binary forms, with or without
!modification, are permitted provided that the following conditions are met:
!    * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
!    * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
!    * The names of the contributors may not be used to endorse or promote products derived from this software without specific prior written permission.

!THIS SOFTWARE IS PROVIDED BY Tom Schoonjans ''AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL Tom Schoonjans BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


PROGRAM xrltest

USE xraylib

IMPLICIT NONE

TYPE (compoundData_C) :: cd_C
TYPE (compoundData_F) :: cd_F

!C_NULL_CHAR needs to be added since these strings will be passed to C functions
CHARACTER (KIND=C_CHAR,LEN=10) :: compound1 = C_CHAR_'Ca(HCO3)2'// C_NULL_CHAR
CHARACTER (KIND=C_CHAR,LEN=5) :: compound2 = C_CHAR_'SiO2'// C_NULL_CHAR
INTEGER :: i
TYPE (Crystal_Struct) :: cryst
REAL (C_FLOAT) :: bragg, q, energy, debye_temp_factor, f0, fp, fpp,&
rel_angle, dw
COMPLEX (C_FLOAT) :: F_H, F_0, F_Hbar
REAL (C_FLOAT), PARAMETER :: PI = 4.D0*DATAN(1.D0)

CALL XRayInit()
!CALL SetHardExit(1)

WRITE (6,'(A)') 'Example of fortran program using xraylib'
WRITE (6,'(A,F12.6)') 'Ca K-alpha Fluorescence Line Energy: ',LineEnergy(20,KA_LINE);
WRITE (6,'(A,F12.6)') 'Fe partial photoionization cs of L3 at 6.0 keV: ',CS_Photo_Partial(26,L3_SHELL,6.0)
WRITE (6,'(A,F12.6)') 'Zr L1 edge energy: ',EdgeEnergy(40,L1_SHELL)
WRITE (6,'(A,F12.6)') 'Pb Lalpha XRF production cs at 20.0 keV (jump approx): ',CS_FluorLine(82,LA_LINE,20.0)
WRITE (6,'(A,F12.6)') 'Pb Lalpha XRF production cs at 20.0 keV (Kissel): ',CS_FluorLine_Kissel(82,LA_LINE,20.0)
WRITE (6,'(A,F12.6)') 'Bi M1N2 radiative rate: ',RadRate(83,M1N2_LINE)
WRITE (6,'(A,F12.6)') 'U M3O3 Fluorescence Line Energy: ',LineEnergy(92,M3O3_LINE);

!CompoundParser tests
IF (CompoundParser(compound1,cd_C) == 0) THEN
        CALL EXIT(1)
ENDIF
CALL compoundDataAssoc(cd_C,cd_F)
WRITE (6,'(A,I4,A,I4,A)') 'Ca(HCO3)2 contains ',cd_F%nAtomsAll,' atoms and ',cd_F%nElements,' elements'
DO i=1,cd_F%nElements
        WRITE (6,'(A,I2,A,F12.6,A)') 'Element ',cd_F%Elements(i),' : ',cd_F%massFractions(i)*100.0_C_DOUBLE,' %'
ENDDO

!Free the memory allocated for the arrays
DEALLOCATE(cd_F%Elements,cd_F%massFractions)


IF (CompoundParser(compound2,cd_C) == 0) THEN
        CALL EXIT(1)
ENDIF
CALL compoundDataAssoc(cd_C,cd_F)
WRITE (6,'(A,I4,A,I4,A)') 'SiO2 contains ',cd_F%nAtomsAll,' atoms and ',cd_F%nElements,' elements'
DO i=1,cd_F%nElements
        WRITE (6,'(A,I2,A,F12.6,A)') 'Element ',cd_F%Elements(i),' : ',cd_F%massFractions(i)*100.0_C_DOUBLE,' %'
ENDDO

DEALLOCATE(cd_F%Elements,cd_F%massFractions)

WRITE (6,'(A,F12.6)') 'Ca(HCO3)2 Rayleigh cs at 10.0 keV: ',CS_Rayl_CP('Ca(HCO3)2'//C_NULL_CHAR,10.0)

WRITE (6,'(A,ES14.6,A,ES14.6,A)') 'CS2 Refractive Index at 10.0 keV : ', &
        Refractive_Index_Re('CS2'//C_NULL_CHAR,10.0,1.261),' - ',Refractive_Index_Im('CS2'//C_NULL_CHAR,10.0,1.261),' i'  
WRITE (6,'(A,ES14.6,A,ES14.6,A)') 'C16H14O3 Refractive Index at 1 keV : ', &
        Refractive_Index_Re('C16H14O3'//C_NULL_CHAR,1.0,1.2),' - ',Refractive_Index_Im('C16H14O3'//C_NULL_CHAR,1.0,1.2),' i'  
WRITE (6,'(A,ES14.6,A,ES14.6,A)') 'SiO2 Refractive Index at 5.0 keV : ', &
        Refractive_Index_Re('SiO2'//C_NULL_CHAR,5.0,2.65),' - ',Refractive_Index_Im('SiO2'//C_NULL_CHAR,5.0,2.65),' i'  
WRITE (6,'(A,F12.6)') 'Compton profile for Fe at pz = 1.1 : ' ,&
        ComptonProfile(26,1.1) 
WRITE (6,'(A,F12.6)') 'M5 Compton profile for Fe at pz = 1.1 : ' ,&
        ComptonProfile_Partial(26,M5_SHELL,1.1) 
WRITE (6,'(A,F12.6)') 'K atomic level width for Fe: ',&
        AtomicLevelWidth(26,K_SHELL)
WRITE (6,'(A,F12.6)') 'Bi L2-M5M5 Auger non-radiative rate: ',&
        AugerRate(86,L2_M5M5_AUGER)
WRITE (6,'(A,F12.6)') 'M1->M5 Coster-Kronig transition probability for Au : ',CosKronTransProb(79,FM15_TRANS)
WRITE (6,'(A,F12.6)') 'L1->L3 Coster-Kronig transition probability for Fe : ',CosKronTransProb(26,FL13_TRANS)
WRITE (6,'(A,F12.6)') 'Au Ma1 XRF production cs at 10.0 keV (Kissel): ',CS_FluorLine_Kissel(79,MA1_LINE,10.0)
WRITE (6,'(A,F12.6)') 'Au Mb XRF production cs at 10.0 keV (Kissel): ',CS_FluorLine_Kissel(79,MB_LINE,10.0)
WRITE (6,'(A,F12.6)') 'Au Mg XRF production cs at 10.0 keV (Kissel): ',CS_FluorLine_Kissel(79,MG_LINE,10.0)
WRITE (6,'(A,F12.6)') 'Pb Malpha XRF production cs at 20.0 keV with cascade effect: ',&
CS_FluorLine_Kissel(82,MA1_LINE,20.0)
WRITE (6,'(A,F12.6)') 'Pb Malpha XRF production cs at 20.0 keV with radiative cascade effect: ',&
CS_FluorLine_Kissel_Radiative_Cascade(82,MA1_LINE,20.0)
WRITE (6,'(A,F12.6)') 'Pb Malpha XRF production cs at 20.0 keV with non-radiative cascade effect: ',&
CS_FluorLine_Kissel_Nonradiative_Cascade(82,MA1_LINE,20.0)
WRITE (6,'(A,F12.6)') 'Pb Malpha XRF production cs at 20.0 keV without cascade effect: ',&
CS_FluorLine_Kissel_no_Cascade(82,MA1_LINE,20.0)


WRITE (6,'(A,A)') 'Symbol of element 26 is: ',AtomicNumberToSymbol(26)
WRITE (6,'(A,I3)') 'Number of element Fe is: ',SymbolToAtomicNumber('Fe')

cryst = Crystal_GetCrystal('Si')
IF (cryst%name .EQ. 'none') CALL EXIT(1)

WRITE (6,'(A,3F12.3)') 'Si unit cell dimensions are ',cryst%a,cryst%b,cryst%c
WRITE (6,'(A,3F12.3)') 'Si unit cell angles are ',&
cryst%alpha,cryst%beta,cryst%gamma
WRITE (6,'(A,F12.3)') 'Si unit cell volume is ',cryst%volume
WRITE (6,'(A)') 'Si atoms at '
WRITE (6,'(A)') ' Z  fraction    X        Y        Z'
DO i=1,cryst%n_atom
        WRITE (6, '(I3,4F9.3)') cryst%atom(i)%Zatom, cryst%atom(i)%fraction,&
        cryst%atom(i)%x, cryst%atom(i)%y, cryst%atom(i)%z
ENDDO

WRITE (6,'(A)') ''

!Si diffraction parameters
WRITE (6, '(A)') 'Si111 at 8 KeV. Incidence at the Bragg angle:'
bragg = Bragg_angle(cryst, 8.0, 1, 1, 1)
WRITE (6, '(A,F12.6,A,F12.6)') '  Bragg angle: Rad: ',bragg,' Deg: ',&
bragg*180.0/PI
q = Q_scattering_amplitude (cryst, 8.0, 1, 1, 1, 1.0)
WRITE (6, '(A, F12.6)') '  Q Scattering amplitude: ',q
energy = 8.0
debye_temp_factor = 1.0
CALL Atomic_Factors (14, energy, q, debye_temp_factor, f0, fp, fpp)

WRITE (6, '(A,F12.6,A,F12.6,A,F12.6)')&
'  Atomic factors (Z=14) f0, fp, fpp: ', f0, ', ',fp, ', i*',fpp

rel_angle = 1.0

F_H = Crystal_F_H_StructureFactor (cryst, energy, 1, 1, 1, debye_temp_factor,&
rel_angle)
WRITE (6, '(A,F12.6,A,F12.6,A)') '  FH(1,1,1) structure factor: (',&
REAL(F_H),', ',AIMAG(F_H),')'

F_0 = Crystal_F_H_StructureFactor (cryst, energy, 0, 0, 0, debye_temp_factor,&
rel_angle)
WRITE (6, '(A,F12.6,A,F12.6,A)') '  F0=FH(0,0,0) structure factor: (',&
REAL(F_0),', ',AIMAG(F_0),')'

WRITE (6,'(A)') ''

! Diamond diffraction parameters
cryst = Crystal_GetCrystal('Diamond')
IF (cryst%name .EQ. 'none') CALL EXIT(1)
WRITE (6,'(A)') 'Diamond 111 at 8 KeV. Incidence at the Bragg angle:'

bragg = Bragg_angle (cryst, energy, 1, 1, 1)
WRITE (6, '(A,F12.6,A,F12.6)') '  Bragg angle: Rad: ',bragg,' Deg: ',&
bragg*180.0/PI

q = Q_scattering_amplitude (cryst, 8.0, 1, 1, 1, rel_angle)
WRITE (6, '(A, F12.6)') '  Q Scattering amplitude: ',q
energy = 8.0
debye_temp_factor = 1.0
CALL Atomic_Factors (6, energy, q, debye_temp_factor, f0, fp, fpp)

WRITE (6, '(A,F12.6,A,F12.6,A,F12.6)')&
'  Atomic factors (Z=6) f0, fp, fpp: ', f0, ', ',fp, ', i*',fpp

F_H = Crystal_F_H_StructureFactor (cryst, energy, 1, 1, 1, debye_temp_factor,&
rel_angle)
WRITE (6, '(A,F12.6,A,F12.6,A)') '  FH(1,1,1) structure factor: (',&
REAL(F_H),', ',AIMAG(F_H),')'

F_0 = Crystal_F_H_StructureFactor (cryst, energy, 0, 0, 0, debye_temp_factor,&
rel_angle)
WRITE (6, '(A,F12.6,A,F12.6,A)') '  F0=FH(0,0,0) structure factor: (',&
REAL(F_0),', ',AIMAG(F_0),')'

F_Hbar = Crystal_F_H_StructureFactor (cryst, energy, -1, -1, -1, debye_temp_factor,&
rel_angle)
 
dw = 1e10 * 2 * (R_E / cryst%volume) * &
(KEV2ANGST * KEV2ANGST/ (energy *energy)) * &
SQRT(ABS(F_H * F_Hbar)) / PI / SIN(2*bragg)

WRITE (6, '(A,F12.6,A)') '  Darwin width: ',1.0E6*dw,' micro-radians'

WRITE (6,'(A)') ''

! Alpha Quartz diffraction parameters

cryst = Crystal_GetCrystal('AlphaQuartz')
IF (cryst%name .EQ. 'none') CALL EXIT(1)
WRITE (6, '(A)') 'Alpha Quartz 020 at 8 KeV. Incidence at the Bragg angle:' 

bragg = Bragg_angle (cryst, energy, 0, 2, 0)
WRITE (6, '(A,F12.6,A,F12.6)') '  Bragg angle: Rad: ',bragg,' Deg: ',&
bragg*180.0/PI

q = Q_scattering_amplitude (cryst, 8.0, 0, 2, 0, rel_angle)
WRITE (6, '(A, F12.6)') '  Q Scattering amplitude: ',q
CALL Atomic_Factors (8, energy, q, debye_temp_factor, f0, fp, fpp)

WRITE (6, '(A,F12.6,A,F12.6,A,F12.6)')&
'  Atomic factors (Z=8) f0, fp, fpp: ', f0, ', ',fp, ', i*',fpp

F_H = Crystal_F_H_StructureFactor (cryst, energy, 0, 2, 0, debye_temp_factor,&
rel_angle)
WRITE (6, '(A,F12.6,A,F12.6,A)') '  FH(0,2,0) structure factor: (',&
REAL(F_H),', ',AIMAG(F_H),')'

F_0 = Crystal_F_H_StructureFactor (cryst, energy, 0, 0, 0, debye_temp_factor,&
rel_angle)
WRITE (6, '(A,F12.6,A,F12.6,A)') '  F0=FH(0,0,0) structure factor: (',&
REAL(F_0),', ',AIMAG(F_0),')'

WRITE (6,'(A)') ''

! Muscovite diffraction parameters

cryst = Crystal_GetCrystal('Muscovite')
IF (cryst%name .EQ. 'none') CALL EXIT(1)
WRITE (6, '(A)') 'Muscovite 331 at 8 KeV. Incidence at the Bragg angle:'

bragg = Bragg_angle (cryst, energy, 3, 3, 1)
WRITE (6, '(A,F12.6,A,F12.6)') '  Bragg angle: Rad: ',bragg,' Deg: ',&
bragg*180.0/PI

q = Q_scattering_amplitude (cryst, 8.0, 3, 3, 1, rel_angle)
WRITE (6, '(A, F12.6)') '  Q Scattering amplitude: ',q
CALL Atomic_Factors (19, energy, q, debye_temp_factor, f0, fp, fpp)

WRITE (6, '(A,F12.6,A,F12.6,A,F12.6)')&
'  Atomic factors (Z=19) f0, fp, fpp: ', f0, ', ',fp, ', i*',fpp

F_H = Crystal_F_H_StructureFactor (cryst, energy, 3, 3, 1, debye_temp_factor,&
rel_angle)
WRITE (6, '(A,F12.6,A,F12.6,A)') '  FH(3,3,1) structure factor: (',&
REAL(F_H),', ',AIMAG(F_H),')'

F_0 = Crystal_F_H_StructureFactor (cryst, energy, 0, 0, 0, debye_temp_factor,&
rel_angle)
WRITE (6, '(A,F12.6,A,F12.6,A)') '  F0=FH(0,0,0) structure factor: (',&
REAL(F_0),', ',AIMAG(F_0),')'



WRITE (6,'(A)') ''
WRITE (6,'(A)') '--------------------------- END OF XRLEXAMPLE3 -------------------------------'
WRITE (6,'(A)') ''
ENDPROGRAM
