/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * sum.c
 *
 * Code generation for function 'sum'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "link_trajectories3D.h"
#include "sum.h"
#include "link_trajectories3D_emxutil.h"

/* Function Definitions */
void b_sum(const emxArray_real_T *x, emxArray_real_T *y)
{
  int vlen;
  int i;
  int xoffset;
  double s;
  int k;
  vlen = y->size[0] * y->size[1];
  y->size[0] = 1;
  y->size[1] = x->size[1];
  emxEnsureCapacity((emxArray__common *)y, vlen, sizeof(double));
  if (x->size[1] == 0) {
    vlen = y->size[0] * y->size[1];
    y->size[0] = 1;
    emxEnsureCapacity((emxArray__common *)y, vlen, sizeof(double));
    i = y->size[1];
    for (vlen = 0; vlen < i; vlen++) {
      y->data[y->size[0] * vlen] = 0.0;
    }
  } else {
    vlen = x->size[0];
    for (i = 0; i + 1 <= x->size[1]; i++) {
      xoffset = i * vlen;
      s = x->data[xoffset];
      for (k = 2; k <= vlen; k++) {
        s += x->data[(xoffset + k) - 1];
      }

      y->data[i] = s;
    }
  }
}

double sum(const emxArray_real_T *x)
{
  double y;
  int k;
  y = x->data[0];
  for (k = 2; k <= x->size[0]; k++) {
    y += x->data[k - 1];
  }

  return y;
}

/* End of code generation (sum.c) */
