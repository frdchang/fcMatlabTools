/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * link_trajectories3D_emxAPI.h
 *
 * Code generation for function 'link_trajectories3D_emxAPI'
 *
 */

#ifndef LINK_TRAJECTORIES3D_EMXAPI_H
#define LINK_TRAJECTORIES3D_EMXAPI_H

/* Include files */
#include <math.h>
#include <stddef.h>
#include <stdlib.h>
#include <string.h>
#include "rt_nonfinite.h"
#include "rtwtypes.h"
#include "link_trajectories3D_types.h"

/* Function Declarations */
extern emxArray_cell_wrap_0 *emxCreateND_cell_wrap_0(int numDimensions, int
  *size);
extern emxArray_real_T *emxCreateND_real_T(int numDimensions, int *size);
extern emxArray_cell_wrap_0 *emxCreateWrapperND_cell_wrap_0(cell_wrap_0 *data,
  int numDimensions, int *size);
extern emxArray_real_T *emxCreateWrapperND_real_T(double *data, int
  numDimensions, int *size);
extern emxArray_cell_wrap_0 *emxCreateWrapper_cell_wrap_0(cell_wrap_0 *data, int
  rows, int cols);
extern emxArray_real_T *emxCreateWrapper_real_T(double *data, int rows, int cols);
extern emxArray_cell_wrap_0 *emxCreate_cell_wrap_0(int rows, int cols);
extern emxArray_real_T *emxCreate_real_T(int rows, int cols);
extern void emxDestroyArray_cell_wrap_0(emxArray_cell_wrap_0 *emxArray);
extern void emxDestroyArray_real_T(emxArray_real_T *emxArray);

#endif

/* End of code generation (link_trajectories3D_emxAPI.h) */
