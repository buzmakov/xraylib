#include <math.h>
#include "splint.h"
#include "xrayglob.h"
#include "xraylib.h"

//Added by Tom Schoonjans





///////////////////////////////////////////////////////////
//                                                       //
//        Photoelectric cross section  (barns/atom)      //
//                  Using the Kissel data                //
//                                                       //
//    Z : atomic number                                  //
//    E : energy (keV)                                   //
//                                                       //
///////////////////////////////////////////////////////////
float CSb_Photo_Total(int Z, float E) {
  double ln_E, ln_sigma, sigma;

  if (Z<1 || Z>ZMAX || NE_Photo_Total_Kissel[Z]<0) {
    ErrorExit("Z out of range in function CSb_Photo_Total");
    return 0;
  }
  if (E <= 0.) {
    ErrorExit("Energy <=0 in function CSb_Photo_Total");
  }
  ln_E = log((double) E);
  splintd(E_Photo_Total_Kissel[Z]-1, Photo_Total_Kissel[Z]-1, Photo_Total_Kissel2[Z]-1,NE_Photo_Total_Kissel[Z], ln_E, &ln_sigma);

  sigma = exp(ln_sigma);

  return (float) sigma; 
}

///////////////////////////////////////////////////////////
//                                                       //
//        Photoelectric cross section  (cm2/g)           //
//                  Using the Kissel data                //
//                                                       //
//    Z : atomic number                                  //
//    E : energy (keV)                                   //
//                                                       //
///////////////////////////////////////////////////////////

float CS_Photo_Total(int Z, float E) {
  return CSb_Photo_Total(Z, E)*AVOGNUM/AtomicWeight_arr[Z];
}


///////////////////////////////////////////////////////////
//                                                       //
//   Partial Photoelectric cross section  (barns/elec)   //
//                  Using the Kissel data                //
//                                                       //
//    Z : atomic number                                  //
//    shell : shell                                      //
//    E : energy (keV)                                   //
//                                                       //
///////////////////////////////////////////////////////////

float CSb_Photo_Partial(int Z, int shell, float E) {
  double ln_E, ln_sigma, sigma;


  if (Z < 1 || Z > ZMAX) {
    ErrorExit("Z out of range in function CSb_Photo_Partial");
    return 0;
  }
  if (shell < 0 || shell >= SHELLNUM_K) {
    ErrorExit("shell out of range in function CSb_Photo_Partial");
    return 0;
  }
  if (E <= 0.0) {
    ErrorExit("Energy <= 0.0 in function CSb_Photo_Partial");
  }
  if (Electron_Config_Kissel[Z][shell] < 1.0E-06 || EdgeEnergy(Z,shell) > E) {
    return 0.0;
  } 
  else {
    ln_E = log((double) E);
    splintd(E_Photo_Partial_Kissel[Z][shell]-1, Photo_Partial_Kissel[Z][shell]-1, Photo_Partial_Kissel2[Z][shell]-1,NE_Photo_Partial_Kissel[Z][shell], ln_E, &ln_sigma);

    sigma = exp(ln_sigma);

    return (float) sigma; 

  }
}

///////////////////////////////////////////////////////////
//                                                       //
//   Partial Photoelectric cross section  (cm2/g)        //
//                  Using the Kissel data                //
//                                                       //
//    Z : atomic number                                  //
//    shell : shell                                      //
//    E : energy (keV)                                   //
//                                                       //
///////////////////////////////////////////////////////////


float CS_Photo_Partial(int Z, int shell, float E) {
  return CSb_Photo_Partial(Z, shell, E)*Electron_Config_Kissel[Z][shell]*AVOGNUM/AtomicWeight_arr[Z];
}


//////////////////////////////////////////////////////////////////////
//                                                                  //
//                    Fluorescent line cross section (cm2/g)        //
//                                                                  //
//          Z : atomic number                                       //
//          E : energy (keV)                                        //
//          line :                                                  //
//            KA_LINE 0                                             //
//            KB_LINE 1                                             //
//            LA_LINE 2                                             //
//            LB_LINE 3                                             //
//                                                                  //
//////////////////////////////////////////////////////////////////////

float CS_FluorLine_Kissel(int Z, int line, float E) {

  if (Z<1 || Z>ZMAX) {
    ErrorExit("Z out of range in function CS_FluorLine_Kissel");
    return 0.0;
  }

  if (E <= 0.) {
    ErrorExit("Energy <=0 in function CS_FluorLine_Kissel");
    return 0.0;
  }

  if (line>=KN5_LINE && line<=KB_LINE) {
    //K lines
    return CS_Photo_Partial(Z, K_SHELL, E)*FluorYield(Z, K_SHELL)*RadRate(Z,line);
  }
  else if (line>=L1N7_LINE && line<=L1M1_LINE) {
    //L1 lines
    return CS_Photo_Partial(Z, L1_SHELL, E)*FluorYield(Z, L1_SHELL)*RadRate(Z,line);
  }
  else if ((line>=L2N7_LINE && line<=L2M1_LINE) || line==LB_LINE) {
    //L2 lines
    return (FluorYield(Z, L2_SHELL)*RadRate(Z,line))*
		(CS_Photo_Partial(Z, L2_SHELL, E)+
		(CS_Photo_Partial(Z, L1_SHELL, E)*CosKronTransProb(Z,F12_TRANS)));
  }
  else if ((line>=L3N7_LINE && line<=L3M1_LINE) || line==LA_LINE) {
    //L3 lines
    return (FluorYield(Z, L3_SHELL)*RadRate(Z,line))*
		(CS_Photo_Partial(Z, L3_SHELL, E)+
		(CS_Photo_Partial(Z, L2_SHELL, E)*CosKronTransProb(Z,F23_TRANS))+
		(CS_Photo_Partial(Z, L1_SHELL, E)*(CosKronTransProb(Z,F13_TRANS) + CosKronTransProb(Z,FP13_TRANS) + CosKronTransProb(Z,F12_TRANS) * CosKronTransProb(Z,F23_TRANS)))
		);

  }
  else {
    ErrorExit("Line not allowed in function CS_FluorLine_Kissel");
    return 0.0;
  }  
}

//////////////////////////////////////////////////////////////////////
//                                                                  //
//                    Fluorescent line cross section (barns/atom)   //
//                                                                  //
//          Z : atomic number                                       //
//          E : energy (keV)                                        //
//          line :                                                  //
//            KA_LINE 0                                             //
//            KB_LINE 1                                             //
//            LA_LINE 2                                             //
//            LB_LINE 3                                             //
//                                                                  //
//////////////////////////////////////////////////////////////////////

float CSb_FluorLine_Kissel(int Z, int line, float E) {
  return CS_FluorLine_Kissel(Z, line, E)*AtomicWeight_arr[Z]/AVOGNUM;
}

//////////////////////////////////////////////////////////////////////
//                                                                  //
//                  Total cross section  (cm2/g)                    //
//         (Photoelectric (Kissel) + Compton + Rayleigh)            //
//                                                                  //
//          Z : atomic number                                       //
//          E : energy (keV)                                        //
//                                                                  //
//////////////////////////////////////////////////////////////////////
float CS_Total_Kissel(int Z, float E) { 

  if (Z<1 || Z>ZMAX || NE_Photo_Total_Kissel[Z]<0 || NE_Rayl[Z]<0 || NE_Compt[Z]<0) {
    ErrorExit("Z out of range in function CS_Total_Kissel");
    return 0;
  }

  if (E <= 0.) {
    ErrorExit("Energy <=0 in function CS_Total_Kissel");
    return 0;
  }

  return CS_Photo_Total(Z, E) + CS_Rayl(Z, E) + CS_Compt(Z, E);

}

//////////////////////////////////////////////////////////////////////
//                                                                  //
//                  Total cross section  (barn/atom)                //
//         (Photoelectric (Kissel) + Compton + Rayleigh)            //
//                                                                  //
//          Z : atomic number                                       //
//          E : energy (keV)                                        //
//                                                                  //
//////////////////////////////////////////////////////////////////////

float CSb_Total_Kissel(int Z, float E) {

  return CS_Total_Kissel(Z,E)*AtomicWeight_arr[Z]/AVOGNUM;
}