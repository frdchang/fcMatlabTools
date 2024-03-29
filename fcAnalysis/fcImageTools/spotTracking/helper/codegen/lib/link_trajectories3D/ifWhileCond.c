/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 * File: ifWhileCond.c
 *
 * MATLAB Coder version            : 3.3
 * C/C++ source code generated on  : 06-Aug-2017 13:49:30
 */

/* Include Files */
#include "rt_nonfinite.h"
#include "link_trajectories3D.h"
#include "ifWhileCond.h"

/* Function Definitions */

/*
 * Arguments    : const emxArray_boolean_T *x
 * Return Type  : boolean_T
 */
boolean_T ifWhileCond(const emxArray_boolean_T *x)
{
  boolean_T y;
  int k;
  boolean_T exitg1;
  y = !(x->size[1] == 0);
  if (y) {
    k = 1;
    exitg1 = false;
    while ((!exitg1) && (k <= x->size[1])) {
      if (!x->data[k - 1]) {
        y = false;
        exitg1 = true;
      } else {
        k++;
      }
    }
  }

  return y;
}

/*
 * File trailer for ifWhileCond.c
 *
 * [EOF]
 */
