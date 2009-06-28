/* StringPrivate.h Copyright 1998,1999 Philippe Mougin.  */
/*   This software is Open Source. See the license.  */  

//////////////  MACROS

#define VERIF_OP2_STRING(METHOD) {if (![operand2 isKindOfClass:[String class]]) FSArgumentError(operand2,1,@"String",METHOD);}
