/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 * File: power.c
 *
 * MATLAB Coder version            : 3.3
 * C/C++ source code generated on  : 06-Aug-2017 13:49:30
 */

/* Include Files */
#include "rt_nonfinite.h"
#include "link_trajectories3D.h"
#include "power.h"
#include "link_trajectories3D_emxutil.h"

/* Function Definitions */

/*
 * Arguments    : const emxArray_real_T *a
 *                emxArray_real_T *y
 * Return Type  : void
 */
void power(const emxArray_real_T *a, emxArray_real_T *y)
{
  int n;
  unsigned int uv0[2];
  int k;
  for (n = 0; n < 2; n++) {
    uv0[n] = (unsigned int)a->size[n];
  }

  n = y->size[0] * y->size[1];
  y->size[0] = (int)uv0[0];
  y->size[1] = (int)uv0[1];
  emxEnsureCapacity((emxArray__common *)y, n, sizeof(double));
  n = a->size[0] * a->size[1];
  for (k = 0; k + 1 <= n; k++) {
    y->data[k] = a->data[k] * a->data[k];
  }
}

/*
 * File trailer for power.c
 *
 * [EOF]
 */
