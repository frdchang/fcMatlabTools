/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * find.c
 *
 * Code generation for function 'find'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "link_trajectories3D.h"
#include "find.h"
#include "link_trajectories3D_emxutil.h"

/* Function Definitions */
void b_eml_find(const emxArray_boolean_T *x, emxArray_int32_T *i)
{
  int nx;
  int idx;
  int ii;
  boolean_T exitg1;
  nx = x->size[0];
  idx = 0;
  ii = i->size[0];
  i->size[0] = x->size[0];
  emxEnsureCapacity((emxArray__common *)i, ii, sizeof(int));
  ii = 1;
  exitg1 = false;
  while ((!exitg1) && (ii <= nx)) {
    if (x->data[ii - 1]) {
      idx++;
      i->data[idx - 1] = ii;
      if (idx >= nx) {
        exitg1 = true;
      } else {
        ii++;
      }
    } else {
      ii++;
    }
  }

  if (x->size[0] == 1) {
    if (idx == 0) {
      ii = i->size[0];
      i->size[0] = 0;
      emxEnsureCapacity((emxArray__common *)i, ii, sizeof(int));
    }
  } else {
    ii = i->size[0];
    if (1 > idx) {
      i->size[0] = 0;
    } else {
      i->size[0] = idx;
    }

    emxEnsureCapacity((emxArray__common *)i, ii, sizeof(int));
  }
}

void eml_find(const emxArray_boolean_T *x, emxArray_int32_T *i)
{
  int nx;
  int idx;
  int ii;
  boolean_T exitg1;
  nx = x->size[1];
  idx = 0;
  ii = i->size[0] * i->size[1];
  i->size[0] = 1;
  i->size[1] = x->size[1];
  emxEnsureCapacity((emxArray__common *)i, ii, sizeof(int));
  ii = 1;
  exitg1 = false;
  while ((!exitg1) && (ii <= nx)) {
    if (x->data[ii - 1]) {
      idx++;
      i->data[idx - 1] = ii;
      if (idx >= nx) {
        exitg1 = true;
      } else {
        ii++;
      }
    } else {
      ii++;
    }
  }

  if (x->size[1] == 1) {
    if (idx == 0) {
      ii = i->size[0] * i->size[1];
      i->size[0] = 1;
      i->size[1] = 0;
      emxEnsureCapacity((emxArray__common *)i, ii, sizeof(int));
    }
  } else {
    ii = i->size[0] * i->size[1];
    if (1 > idx) {
      i->size[1] = 0;
    } else {
      i->size[1] = idx;
    }

    emxEnsureCapacity((emxArray__common *)i, ii, sizeof(int));
  }
}

/* End of code generation (find.c) */
