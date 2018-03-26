/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 * File: _coder_link_trajectories3D_api.c
 *
 * MATLAB Coder version            : 3.3
 * C/C++ source code generated on  : 06-Aug-2017 13:49:30
 */

/* Include Files */
#include "tmwtypes.h"
#include "_coder_link_trajectories3D_api.h"
#include "_coder_link_trajectories3D_mex.h"

/* Type Definitions */
#ifndef struct_emxArray__common
#define struct_emxArray__common

struct emxArray__common
{
  void *data;
  int32_T *size;
  int32_T allocatedSize;
  int32_T numDimensions;
  boolean_T canFreeData;
};

#endif                                 /*struct_emxArray__common*/

#ifndef typedef_emxArray__common
#define typedef_emxArray__common

typedef struct emxArray__common emxArray__common;

#endif                                 /*typedef_emxArray__common*/

/* Variable Definitions */
emlrtCTX emlrtRootTLSGlobal = NULL;
emlrtContext emlrtContextGlobal = { true,/* bFirstTime */
  false,                               /* bInitialized */
  131450U,                             /* fVersionInfo */
  NULL,                                /* fErrorFunction */
  "link_trajectories3D",               /* fFunctionName */
  NULL,                                /* fRTCallStack */
  false,                               /* bDebugMode */
  { 2045744189U, 2170104910U, 2743257031U, 4284093946U },/* fSigWrd */
  NULL                                 /* fSigMem */
};

/* Function Declarations */
static void b_emlrt_marshallIn(const mxArray *u, const emlrtMsgIdentifier
  *parentId, emxArray_cell_wrap_0 *y);
static void c_emlrt_marshallIn(const mxArray *u, const emlrtMsgIdentifier
  *parentId, emxArray_real_T *y);
static real_T d_emlrt_marshallIn(const mxArray *L, const char_T *identifier);
static real_T e_emlrt_marshallIn(const mxArray *u, const emlrtMsgIdentifier
  *parentId);
static void emlrt_marshallIn(const mxArray *peaks, const char_T *identifier,
  emxArray_cell_wrap_0 *y);
static const mxArray *emlrt_marshallOut(const emxArray_cell_wrap_0 *u);
static void emxEnsureCapacity(emxArray__common *emxArray, int32_T oldNumel,
  uint32_T elementSize);
static void emxEnsureCapacity_cell_wrap_0(emxArray_cell_wrap_0 *emxArray,
  int32_T oldNumel);
static void emxExpand_cell_wrap_0(emxArray_cell_wrap_0 *emxArray, int32_T
  fromIndex, int32_T toIndex);
static void emxFreeStruct_cell_wrap_0(cell_wrap_0 *pStruct);
static void emxFree_cell_wrap_0(emxArray_cell_wrap_0 **pEmxArray);
static void emxFree_real_T(emxArray_real_T **pEmxArray);
static void emxInitStruct_cell_wrap_0(cell_wrap_0 *pStruct, boolean_T doPush);
static void emxInit_cell_wrap_0(emxArray_cell_wrap_0 **pEmxArray, int32_T
  numDimensions, boolean_T doPush);
static void emxInit_real_T(emxArray_real_T **pEmxArray, int32_T numDimensions,
  boolean_T doPush);
static void emxTrim_cell_wrap_0(emxArray_cell_wrap_0 *emxArray, int32_T
  fromIndex, int32_T toIndex);
static void f_emlrt_marshallIn(const mxArray *src, const emlrtMsgIdentifier
  *msgId, emxArray_real_T *ret);
static real_T g_emlrt_marshallIn(const mxArray *src, const emlrtMsgIdentifier
  *msgId);

/* Function Definitions */

/*
 * Arguments    : const mxArray *u
 *                const emlrtMsgIdentifier *parentId
 *                emxArray_cell_wrap_0 *y
 * Return Type  : void
 */
static void b_emlrt_marshallIn(const mxArray *u, const emlrtMsgIdentifier
  *parentId, emxArray_cell_wrap_0 *y)
{
  emlrtMsgIdentifier thisId;
  int32_T i;
  int32_T iv0[2];
  boolean_T bv0[2];
  int32_T sizes[2];
  int32_T n;
  char_T str[11];
  thisId.fParent = parentId;
  thisId.bParentIsCell = true;
  for (i = 0; i < 2; i++) {
    iv0[i] = -1;
    bv0[i] = true;
  }

  emlrtCheckVsCell(emlrtRootTLSGlobal, parentId, u, 2U, iv0, bv0, sizes);
  i = y->size[0] * y->size[1];
  y->size[0] = sizes[0];
  y->size[1] = sizes[1];
  emxEnsureCapacity_cell_wrap_0(y, i);
  n = sizes[0] * sizes[1];
  for (i = 0; i < n; i++) {
    sprintf(&str[0], "%d", i + 1);
    thisId.fIdentifier = &str[0];
    c_emlrt_marshallIn(emlrtAlias(emlrtGetCell(emlrtRootTLSGlobal, parentId, u,
      i)), &thisId, y->data[i].f1);
  }

  emlrtDestroyArray(&u);
}

/*
 * Arguments    : const mxArray *u
 *                const emlrtMsgIdentifier *parentId
 *                emxArray_real_T *y
 * Return Type  : void
 */
static void c_emlrt_marshallIn(const mxArray *u, const emlrtMsgIdentifier
  *parentId, emxArray_real_T *y)
{
  f_emlrt_marshallIn(emlrtAlias(u), parentId, y);
  emlrtDestroyArray(&u);
}

/*
 * Arguments    : const mxArray *L
 *                const char_T *identifier
 * Return Type  : real_T
 */
static real_T d_emlrt_marshallIn(const mxArray *L, const char_T *identifier)
{
  real_T y;
  emlrtMsgIdentifier thisId;
  thisId.fIdentifier = (const char *)identifier;
  thisId.fParent = NULL;
  thisId.bParentIsCell = false;
  y = e_emlrt_marshallIn(emlrtAlias(L), &thisId);
  emlrtDestroyArray(&L);
  return y;
}

/*
 * Arguments    : const mxArray *u
 *                const emlrtMsgIdentifier *parentId
 * Return Type  : real_T
 */
static real_T e_emlrt_marshallIn(const mxArray *u, const emlrtMsgIdentifier
  *parentId)
{
  real_T y;
  y = g_emlrt_marshallIn(emlrtAlias(u), parentId);
  emlrtDestroyArray(&u);
  return y;
}

/*
 * Arguments    : const mxArray *peaks
 *                const char_T *identifier
 *                emxArray_cell_wrap_0 *y
 * Return Type  : void
 */
static void emlrt_marshallIn(const mxArray *peaks, const char_T *identifier,
  emxArray_cell_wrap_0 *y)
{
  emlrtMsgIdentifier thisId;
  thisId.fIdentifier = (const char *)identifier;
  thisId.fParent = NULL;
  thisId.bParentIsCell = false;
  b_emlrt_marshallIn(emlrtAlias(peaks), &thisId, y);
  emlrtDestroyArray(&peaks);
}

/*
 * Arguments    : const emxArray_cell_wrap_0 *u
 * Return Type  : const mxArray *
 */
static const mxArray *emlrt_marshallOut(const emxArray_cell_wrap_0 *u)
{
  const mxArray *y;
  int32_T i0;
  int32_T n;
  emxArray_real_T *b_u;
  int32_T i1;
  int32_T loop_ub;
  const mxArray *b_y;
  const mxArray *m0;
  real_T *pData;
  int32_T i;
  emlrtHeapReferenceStackEnterFcnR2012b(emlrtRootTLSGlobal);
  y = NULL;
  emlrtAssign(&y, emlrtCreateCellArrayR2014a(2, *(int32_T (*)[2])u->size));
  i0 = 0;
  n = u->size[0] * u->size[1];
  emxInit_real_T(&b_u, 2, true);
  while (i0 < n) {
    i1 = b_u->size[0] * b_u->size[1];
    b_u->size[0] = u->data[i0].f1->size[0];
    emxEnsureCapacity((emxArray__common *)b_u, i1, sizeof(real_T));
    i1 = b_u->size[0] * b_u->size[1];
    b_u->size[1] = u->data[i0].f1->size[1];
    emxEnsureCapacity((emxArray__common *)b_u, i1, sizeof(real_T));
    loop_ub = u->data[i0].f1->size[0] * u->data[i0].f1->size[1];
    for (i1 = 0; i1 < loop_ub; i1++) {
      b_u->data[i1] = u->data[i0].f1->data[i1];
    }

    b_y = NULL;
    m0 = emlrtCreateNumericArray(2, *(int32_T (*)[2])b_u->size, mxDOUBLE_CLASS,
      mxREAL);
    pData = (real_T *)mxGetPr(m0);
    i1 = 0;
    for (loop_ub = 0; loop_ub < b_u->size[1]; loop_ub++) {
      for (i = 0; i < b_u->size[0]; i++) {
        pData[i1] = b_u->data[i + b_u->size[0] * loop_ub];
        i1++;
      }
    }

    emlrtAssign(&b_y, m0);
    emlrtSetCell(y, i0, b_y);
    i0++;
  }

  emxFree_real_T(&b_u);
  emlrtHeapReferenceStackLeaveFcnR2012b(emlrtRootTLSGlobal);
  return y;
}

/*
 * Arguments    : emxArray__common *emxArray
 *                int32_T oldNumel
 *                uint32_T elementSize
 * Return Type  : void
 */
static void emxEnsureCapacity(emxArray__common *emxArray, int32_T oldNumel,
  uint32_T elementSize)
{
  int32_T newNumel;
  int32_T i;
  void *newData;
  if (oldNumel < 0) {
    oldNumel = 0;
  }

  newNumel = 1;
  for (i = 0; i < emxArray->numDimensions; i++) {
    newNumel *= emxArray->size[i];
  }

  if (newNumel > emxArray->allocatedSize) {
    i = emxArray->allocatedSize;
    if (i < 16) {
      i = 16;
    }

    while (i < newNumel) {
      if (i > 1073741823) {
        i = MAX_int32_T;
      } else {
        i <<= 1;
      }
    }

    newData = emlrtCallocMex((uint32_T)i, elementSize);
    if (emxArray->data != NULL) {
      memcpy(newData, emxArray->data, elementSize * oldNumel);
      if (emxArray->canFreeData) {
        emlrtFreeMex(emxArray->data);
      }
    }

    emxArray->data = newData;
    emxArray->allocatedSize = i;
    emxArray->canFreeData = true;
  }
}

/*
 * Arguments    : emxArray_cell_wrap_0 *emxArray
 *                int32_T oldNumel
 * Return Type  : void
 */
static void emxEnsureCapacity_cell_wrap_0(emxArray_cell_wrap_0 *emxArray,
  int32_T oldNumel)
{
  uint32_T elementSize;
  int32_T newNumel;
  int32_T i;
  void *newData;
  elementSize = sizeof(cell_wrap_0);
  if (oldNumel < 0) {
    oldNumel = 0;
  }

  newNumel = 1;
  for (i = 0; i < emxArray->numDimensions; i++) {
    newNumel *= emxArray->size[i];
  }

  if (newNumel > emxArray->allocatedSize) {
    i = emxArray->allocatedSize;
    if (i < 16) {
      i = 16;
    }

    while (i < newNumel) {
      if (i > 1073741823) {
        i = MAX_int32_T;
      } else {
        i <<= 1;
      }
    }

    newData = emlrtCallocMex((uint32_T)i, elementSize);
    if (emxArray->data != NULL) {
      memcpy(newData, (void *)emxArray->data, elementSize * oldNumel);
      if (emxArray->canFreeData) {
        emlrtFreeMex((void *)emxArray->data);
      }
    }

    emxArray->data = (cell_wrap_0 *)newData;
    emxArray->allocatedSize = i;
    emxArray->canFreeData = true;
  }

  if (oldNumel > newNumel) {
    emxTrim_cell_wrap_0(emxArray, newNumel, oldNumel);
  } else {
    if (oldNumel < newNumel) {
      emxExpand_cell_wrap_0(emxArray, oldNumel, newNumel);
    }
  }
}

/*
 * Arguments    : emxArray_cell_wrap_0 *emxArray
 *                int32_T fromIndex
 *                int32_T toIndex
 * Return Type  : void
 */
static void emxExpand_cell_wrap_0(emxArray_cell_wrap_0 *emxArray, int32_T
  fromIndex, int32_T toIndex)
{
  int32_T i;
  for (i = fromIndex; i < toIndex; i++) {
    emxInitStruct_cell_wrap_0(&emxArray->data[i], false);
  }
}

/*
 * Arguments    : cell_wrap_0 *pStruct
 * Return Type  : void
 */
static void emxFreeStruct_cell_wrap_0(cell_wrap_0 *pStruct)
{
  emxFree_real_T(&pStruct->f1);
}

/*
 * Arguments    : emxArray_cell_wrap_0 **pEmxArray
 * Return Type  : void
 */
static void emxFree_cell_wrap_0(emxArray_cell_wrap_0 **pEmxArray)
{
  int32_T numEl;
  int32_T i;
  if (*pEmxArray != (emxArray_cell_wrap_0 *)NULL) {
    if ((*pEmxArray)->data != (cell_wrap_0 *)NULL) {
      numEl = 1;
      for (i = 0; i < (*pEmxArray)->numDimensions; i++) {
        numEl *= (*pEmxArray)->size[i];
      }

      for (i = 0; i < numEl; i++) {
        emxFreeStruct_cell_wrap_0(&(*pEmxArray)->data[i]);
      }

      if ((*pEmxArray)->canFreeData) {
        emlrtFreeMex((void *)(*pEmxArray)->data);
      }
    }

    emlrtFreeMex((void *)(*pEmxArray)->size);
    emlrtFreeMex((void *)*pEmxArray);
    *pEmxArray = (emxArray_cell_wrap_0 *)NULL;
  }
}

/*
 * Arguments    : emxArray_real_T **pEmxArray
 * Return Type  : void
 */
static void emxFree_real_T(emxArray_real_T **pEmxArray)
{
  if (*pEmxArray != (emxArray_real_T *)NULL) {
    if (((*pEmxArray)->data != (real_T *)NULL) && (*pEmxArray)->canFreeData) {
      emlrtFreeMex((void *)(*pEmxArray)->data);
    }

    emlrtFreeMex((void *)(*pEmxArray)->size);
    emlrtFreeMex((void *)*pEmxArray);
    *pEmxArray = (emxArray_real_T *)NULL;
  }
}

/*
 * Arguments    : cell_wrap_0 *pStruct
 *                boolean_T doPush
 * Return Type  : void
 */
static void emxInitStruct_cell_wrap_0(cell_wrap_0 *pStruct, boolean_T doPush)
{
  emxInit_real_T(&pStruct->f1, 2, doPush);
}

/*
 * Arguments    : emxArray_cell_wrap_0 **pEmxArray
 *                int32_T numDimensions
 *                boolean_T doPush
 * Return Type  : void
 */
static void emxInit_cell_wrap_0(emxArray_cell_wrap_0 **pEmxArray, int32_T
  numDimensions, boolean_T doPush)
{
  emxArray_cell_wrap_0 *emxArray;
  int32_T i;
  *pEmxArray = (emxArray_cell_wrap_0 *)emlrtMallocMex(sizeof
    (emxArray_cell_wrap_0));
  if (doPush) {
    emlrtPushHeapReferenceStackR2012b(emlrtRootTLSGlobal, (void *)pEmxArray,
      (void (*)(void *))emxFree_cell_wrap_0);
  }

  emxArray = *pEmxArray;
  emxArray->data = (cell_wrap_0 *)NULL;
  emxArray->numDimensions = numDimensions;
  emxArray->size = (int32_T *)emlrtMallocMex((uint32_T)(sizeof(int32_T)
    * numDimensions));
  emxArray->allocatedSize = 0;
  emxArray->canFreeData = true;
  for (i = 0; i < numDimensions; i++) {
    emxArray->size[i] = 0;
  }
}

/*
 * Arguments    : emxArray_real_T **pEmxArray
 *                int32_T numDimensions
 *                boolean_T doPush
 * Return Type  : void
 */
static void emxInit_real_T(emxArray_real_T **pEmxArray, int32_T numDimensions,
  boolean_T doPush)
{
  emxArray_real_T *emxArray;
  int32_T i;
  *pEmxArray = (emxArray_real_T *)emlrtMallocMex(sizeof(emxArray_real_T));
  if (doPush) {
    emlrtPushHeapReferenceStackR2012b(emlrtRootTLSGlobal, (void *)pEmxArray,
      (void (*)(void *))emxFree_real_T);
  }

  emxArray = *pEmxArray;
  emxArray->data = (real_T *)NULL;
  emxArray->numDimensions = numDimensions;
  emxArray->size = (int32_T *)emlrtMallocMex((uint32_T)(sizeof(int32_T)
    * numDimensions));
  emxArray->allocatedSize = 0;
  emxArray->canFreeData = true;
  for (i = 0; i < numDimensions; i++) {
    emxArray->size[i] = 0;
  }
}

/*
 * Arguments    : emxArray_cell_wrap_0 *emxArray
 *                int32_T fromIndex
 *                int32_T toIndex
 * Return Type  : void
 */
static void emxTrim_cell_wrap_0(emxArray_cell_wrap_0 *emxArray, int32_T
  fromIndex, int32_T toIndex)
{
  int32_T i;
  for (i = fromIndex; i < toIndex; i++) {
    emxFreeStruct_cell_wrap_0(&emxArray->data[i]);
  }
}

/*
 * Arguments    : const mxArray *src
 *                const emlrtMsgIdentifier *msgId
 *                emxArray_real_T *ret
 * Return Type  : void
 */
static void f_emlrt_marshallIn(const mxArray *src, const emlrtMsgIdentifier
  *msgId, emxArray_real_T *ret)
{
  static const int32_T dims[2] = { -1, -1 };

  const boolean_T bv1[2] = { true, true };

  int32_T iv1[2];
  int32_T i2;
  emlrtCheckVsBuiltInR2012b(emlrtRootTLSGlobal, msgId, src, "double", false, 2U,
    dims, &bv1[0], iv1);
  i2 = ret->size[0] * ret->size[1];
  ret->size[0] = iv1[0];
  ret->size[1] = iv1[1];
  emxEnsureCapacity((emxArray__common *)ret, i2, sizeof(real_T));
  emlrtImportArrayR2015b(emlrtRootTLSGlobal, src, ret->data, 8, false);
  emlrtDestroyArray(&src);
}

/*
 * Arguments    : const mxArray *src
 *                const emlrtMsgIdentifier *msgId
 * Return Type  : real_T
 */
static real_T g_emlrt_marshallIn(const mxArray *src, const emlrtMsgIdentifier
  *msgId)
{
  real_T ret;
  static const int32_T dims = 0;
  emlrtCheckBuiltInR2012b(emlrtRootTLSGlobal, msgId, src, "double", false, 0U,
    &dims);
  ret = *(real_T *)mxGetData(src);
  emlrtDestroyArray(&src);
  return ret;
}

/*
 * Arguments    : const mxArray * const prhs[2]
 *                const mxArray *plhs[1]
 * Return Type  : void
 */
void link_trajectories3D_api(const mxArray * const prhs[2], const mxArray *plhs
  [1])
{
  emxArray_cell_wrap_0 *peaks;
  real_T L;
  emlrtHeapReferenceStackEnterFcnR2012b(emlrtRootTLSGlobal);
  emxInit_cell_wrap_0(&peaks, 2, true);

  /* Marshall function inputs */
  emlrt_marshallIn(emlrtAliasP(prhs[0]), "peaks", peaks);
  L = d_emlrt_marshallIn(emlrtAliasP(prhs[1]), "L");

  /* Invoke the target function */
  link_trajectories3D(peaks, L);

  /* Marshall function outputs */
  plhs[0] = emlrt_marshallOut(peaks);
  emxFree_cell_wrap_0(&peaks);
  emlrtHeapReferenceStackLeaveFcnR2012b(emlrtRootTLSGlobal);
}

/*
 * Arguments    : void
 * Return Type  : void
 */
void link_trajectories3D_atexit(void)
{
  mexFunctionCreateRootTLS();
  emlrtEnterRtStackR2012b(emlrtRootTLSGlobal);
  emlrtLeaveRtStackR2012b(emlrtRootTLSGlobal);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
  link_trajectories3D_xil_terminate();
}

/*
 * Arguments    : void
 * Return Type  : void
 */
void link_trajectories3D_initialize(void)
{
  mexFunctionCreateRootTLS();
  emlrtClearAllocCountR2012b(emlrtRootTLSGlobal, false, 0U, 0);
  emlrtEnterRtStackR2012b(emlrtRootTLSGlobal);
  emlrtFirstTimeR2012b(emlrtRootTLSGlobal);
}

/*
 * Arguments    : void
 * Return Type  : void
 */
void link_trajectories3D_terminate(void)
{
  emlrtLeaveRtStackR2012b(emlrtRootTLSGlobal);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
}

/*
 * File trailer for _coder_link_trajectories3D_api.c
 *
 * [EOF]
 */
