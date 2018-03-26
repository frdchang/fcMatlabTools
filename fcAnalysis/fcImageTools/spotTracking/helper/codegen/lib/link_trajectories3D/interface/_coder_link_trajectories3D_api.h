/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 * File: _coder_link_trajectories3D_api.h
 *
 * MATLAB Coder version            : 3.3
 * C/C++ source code generated on  : 06-Aug-2017 13:49:30
 */

#ifndef _CODER_LINK_TRAJECTORIES3D_API_H
#define _CODER_LINK_TRAJECTORIES3D_API_H

/* Include Files */
#include "tmwtypes.h"
#include "mex.h"
#include "emlrt.h"
#include <stddef.h>
#include <stdlib.h>
#include "_coder_link_trajectories3D_api.h"

/* Type Definitions */
#ifndef struct_emxArray_real_T
#define struct_emxArray_real_T

struct emxArray_real_T
{
  real_T *data;
  int32_T *size;
  int32_T allocatedSize;
  int32_T numDimensions;
  boolean_T canFreeData;
};

#endif                                 /*struct_emxArray_real_T*/

#ifndef typedef_emxArray_real_T
#define typedef_emxArray_real_T

typedef struct emxArray_real_T emxArray_real_T;

#endif                                 /*typedef_emxArray_real_T*/

#ifndef typedef_cell_wrap_0
#define typedef_cell_wrap_0

typedef struct {
  emxArray_real_T *f1;
} cell_wrap_0;

#endif                                 /*typedef_cell_wrap_0*/

#ifndef struct_emxArray_cell_wrap_0
#define struct_emxArray_cell_wrap_0

struct emxArray_cell_wrap_0
{
  cell_wrap_0 *data;
  int32_T *size;
  int32_T allocatedSize;
  int32_T numDimensions;
  boolean_T canFreeData;
};

#endif                                 /*struct_emxArray_cell_wrap_0*/

#ifndef typedef_emxArray_cell_wrap_0
#define typedef_emxArray_cell_wrap_0

typedef struct emxArray_cell_wrap_0 emxArray_cell_wrap_0;

#endif                                 /*typedef_emxArray_cell_wrap_0*/

/* Variable Declarations */
extern emlrtCTX emlrtRootTLSGlobal;
extern emlrtContext emlrtContextGlobal;

/* Function Declarations */
extern void link_trajectories3D(emxArray_cell_wrap_0 *peaks, real_T L);
extern void link_trajectories3D_api(const mxArray * const prhs[2], const mxArray
  *plhs[1]);
extern void link_trajectories3D_atexit(void);
extern void link_trajectories3D_initialize(void);
extern void link_trajectories3D_terminate(void);
extern void link_trajectories3D_xil_terminate(void);

#endif

/*
 * File trailer for _coder_link_trajectories3D_api.h
 *
 * [EOF]
 */
