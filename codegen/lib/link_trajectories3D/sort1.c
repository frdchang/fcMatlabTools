/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * sort1.c
 *
 * Code generation for function 'sort1'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "link_trajectories3D.h"
#include "sort1.h"
#include "link_trajectories3D_emxutil.h"
#include "sortIdx.h"

/* Function Definitions */
void sort(emxArray_real_T *x, emxArray_int32_T *idx)
{
  emxArray_real_T *vwork;
  int i2;
  int x_idx_0;
  int i3;
  emxArray_int32_T *iidx;
  emxInit_real_T1(&vwork, 1);
  i2 = x->size[1];
  x_idx_0 = x->size[1];
  i3 = vwork->size[0];
  vwork->size[0] = x_idx_0;
  emxEnsureCapacity((emxArray__common *)vwork, i3, sizeof(double));
  i3 = idx->size[0] * idx->size[1];
  idx->size[0] = 1;
  idx->size[1] = x->size[1];
  emxEnsureCapacity((emxArray__common *)idx, i3, sizeof(int));
  for (x_idx_0 = 0; x_idx_0 + 1 <= i2; x_idx_0++) {
    vwork->data[x_idx_0] = x->data[x_idx_0];
  }

  emxInit_int32_T(&iidx, 1);
  sortIdx(vwork, iidx);
  for (x_idx_0 = 0; x_idx_0 + 1 <= i2; x_idx_0++) {
    x->data[x_idx_0] = vwork->data[x_idx_0];
    idx->data[x_idx_0] = iidx->data[x_idx_0];
  }

  emxFree_int32_T(&iidx);
  emxFree_real_T(&vwork);
}

/* End of code generation (sort1.c) */
