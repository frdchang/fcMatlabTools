/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 * File: eml_setop.c
 *
 * MATLAB Coder version            : 3.3
 * C/C++ source code generated on  : 06-Aug-2017 13:49:30
 */

/* Include Files */
#include "rt_nonfinite.h"
#include "link_trajectories3D.h"
#include "eml_setop.h"
#include "link_trajectories3D_emxutil.h"

/* Function Declarations */
static double skip_to_last_equal_value(int *k, const emxArray_real_T *x);

/* Function Definitions */

/*
 * Arguments    : int *k
 *                const emxArray_real_T *x
 * Return Type  : double
 */
static double skip_to_last_equal_value(int *k, const emxArray_real_T *x)
{
  double xk;
  boolean_T exitg1;
  double absxk;
  int exponent;
  boolean_T p;
  xk = x->data[*k - 1];
  exitg1 = false;
  while ((!exitg1) && (*k < x->size[0])) {
    absxk = fabs(xk / 2.0);
    if (absxk <= 2.2250738585072014E-308) {
      absxk = 4.94065645841247E-324;
    } else {
      frexp(absxk, &exponent);
      absxk = ldexp(1.0, exponent - 53);
    }

    p = (fabs(xk - x->data[*k]) < absxk);
    if (p) {
      (*k)++;
    } else {
      exitg1 = true;
    }
  }

  return xk;
}

/*
 * Arguments    : const emxArray_real_T *a
 *                const emxArray_real_T *b
 *                emxArray_real_T *c
 *                emxArray_int32_T *ia
 *                emxArray_int32_T *ib
 * Return Type  : void
 */
void b_do_vectors(const emxArray_real_T *a, const emxArray_real_T *b,
                  emxArray_real_T *c, emxArray_int32_T *ia, emxArray_int32_T *ib)
{
  int iafirst;
  int ncmax;
  int ialast;
  int nc;
  int ibfirst;
  int iblast;
  int b_ialast;
  double ak;
  int b_iblast;
  emxArray_int32_T *b_ia;
  double bk;
  double absxk;
  int exponent;
  emxArray_int32_T *b_ib;
  emxArray_real_T *b_c;
  iafirst = a->size[0];
  ncmax = b->size[0];
  if (iafirst < ncmax) {
    ncmax = iafirst;
  }

  ialast = c->size[0];
  c->size[0] = ncmax;
  emxEnsureCapacity((emxArray__common *)c, ialast, sizeof(double));
  ialast = ia->size[0];
  ia->size[0] = ncmax;
  emxEnsureCapacity((emxArray__common *)ia, ialast, sizeof(int));
  ialast = ib->size[0];
  ib->size[0] = ncmax;
  emxEnsureCapacity((emxArray__common *)ib, ialast, sizeof(int));
  nc = 0;
  iafirst = 0;
  ialast = 1;
  ibfirst = 0;
  iblast = 1;
  while ((ialast <= a->size[0]) && (iblast <= b->size[0])) {
    b_ialast = ialast;
    ak = skip_to_last_equal_value(&b_ialast, a);
    ialast = b_ialast;
    b_iblast = iblast;
    bk = skip_to_last_equal_value(&b_iblast, b);
    iblast = b_iblast;
    absxk = fabs(bk / 2.0);
    if (absxk <= 2.2250738585072014E-308) {
      absxk = 4.94065645841247E-324;
    } else {
      frexp(absxk, &exponent);
      absxk = ldexp(1.0, exponent - 53);
    }

    if (fabs(bk - ak) < absxk) {
      nc++;
      c->data[nc - 1] = ak;
      ia->data[nc - 1] = iafirst + 1;
      ib->data[nc - 1] = ibfirst + 1;
      ialast = b_ialast + 1;
      iafirst = b_ialast;
      iblast = b_iblast + 1;
      ibfirst = b_iblast;
    } else if (ak < bk) {
      ialast = b_ialast + 1;
      iafirst = b_ialast;
    } else {
      iblast = b_iblast + 1;
      ibfirst = b_iblast;
    }
  }

  if (ncmax > 0) {
    if (1 > nc) {
      iafirst = 0;
    } else {
      iafirst = nc;
    }

    emxInit_int32_T(&b_ia, 1);
    ialast = b_ia->size[0];
    b_ia->size[0] = iafirst;
    emxEnsureCapacity((emxArray__common *)b_ia, ialast, sizeof(int));
    for (ialast = 0; ialast < iafirst; ialast++) {
      b_ia->data[ialast] = ia->data[ialast];
    }

    ialast = ia->size[0];
    ia->size[0] = b_ia->size[0];
    emxEnsureCapacity((emxArray__common *)ia, ialast, sizeof(int));
    iafirst = b_ia->size[0];
    for (ialast = 0; ialast < iafirst; ialast++) {
      ia->data[ialast] = b_ia->data[ialast];
    }

    emxFree_int32_T(&b_ia);
    if (1 > nc) {
      iafirst = 0;
    } else {
      iafirst = nc;
    }

    emxInit_int32_T(&b_ib, 1);
    ialast = b_ib->size[0];
    b_ib->size[0] = iafirst;
    emxEnsureCapacity((emxArray__common *)b_ib, ialast, sizeof(int));
    for (ialast = 0; ialast < iafirst; ialast++) {
      b_ib->data[ialast] = ib->data[ialast];
    }

    ialast = ib->size[0];
    ib->size[0] = b_ib->size[0];
    emxEnsureCapacity((emxArray__common *)ib, ialast, sizeof(int));
    iafirst = b_ib->size[0];
    for (ialast = 0; ialast < iafirst; ialast++) {
      ib->data[ialast] = b_ib->data[ialast];
    }

    emxFree_int32_T(&b_ib);
    if (1 > nc) {
      iafirst = 0;
    } else {
      iafirst = nc;
    }

    emxInit_real_T1(&b_c, 1);
    ialast = b_c->size[0];
    b_c->size[0] = iafirst;
    emxEnsureCapacity((emxArray__common *)b_c, ialast, sizeof(double));
    for (ialast = 0; ialast < iafirst; ialast++) {
      b_c->data[ialast] = c->data[ialast];
    }

    ialast = c->size[0];
    c->size[0] = b_c->size[0];
    emxEnsureCapacity((emxArray__common *)c, ialast, sizeof(double));
    iafirst = b_c->size[0];
    for (ialast = 0; ialast < iafirst; ialast++) {
      c->data[ialast] = b_c->data[ialast];
    }

    emxFree_real_T(&b_c);
  }
}

/*
 * Arguments    : const emxArray_real_T *a
 *                const emxArray_real_T *b
 *                emxArray_real_T *c
 *                emxArray_int32_T *ia
 *                emxArray_int32_T *ib
 * Return Type  : void
 */
void do_vectors(const emxArray_real_T *a, const emxArray_real_T *b,
                emxArray_real_T *c, emxArray_int32_T *ia, emxArray_int32_T *ib)
{
  int na;
  int nb;
  int ncmax;
  int ibfirst;
  int nc;
  int nia;
  int nib;
  int iafirst;
  int ialast;
  int iblast;
  int b_ialast;
  double ak;
  int b_iblast;
  double bk;
  double absxk;
  emxArray_int32_T *b_ia;
  int exponent;
  emxArray_int32_T *b_ib;
  emxArray_real_T *b_c;
  na = a->size[0];
  nb = b->size[0];
  ncmax = a->size[0] + b->size[0];
  ibfirst = c->size[0];
  c->size[0] = ncmax;
  emxEnsureCapacity((emxArray__common *)c, ibfirst, sizeof(double));
  ibfirst = ia->size[0];
  ia->size[0] = a->size[0];
  emxEnsureCapacity((emxArray__common *)ia, ibfirst, sizeof(int));
  ibfirst = ib->size[0];
  ib->size[0] = b->size[0];
  emxEnsureCapacity((emxArray__common *)ib, ibfirst, sizeof(int));
  nc = -1;
  nia = -1;
  nib = 0;
  iafirst = 1;
  ialast = 1;
  ibfirst = 0;
  iblast = 1;
  while ((ialast <= na) && (iblast <= nb)) {
    b_ialast = ialast;
    ak = skip_to_last_equal_value(&b_ialast, a);
    ialast = b_ialast;
    b_iblast = iblast;
    bk = skip_to_last_equal_value(&b_iblast, b);
    iblast = b_iblast;
    absxk = fabs(bk / 2.0);
    if (absxk <= 2.2250738585072014E-308) {
      absxk = 4.94065645841247E-324;
    } else {
      frexp(absxk, &exponent);
      absxk = ldexp(1.0, exponent - 53);
    }

    if (fabs(bk - ak) < absxk) {
      nc++;
      c->data[nc] = ak;
      nia++;
      ia->data[nia] = iafirst;
      ialast = b_ialast + 1;
      iafirst = b_ialast + 1;
      iblast = b_iblast + 1;
      ibfirst = b_iblast;
    } else if (ak < bk) {
      nc++;
      nia++;
      c->data[nc] = ak;
      ia->data[nia] = iafirst;
      ialast = b_ialast + 1;
      iafirst = b_ialast + 1;
    } else {
      nc++;
      nib++;
      c->data[nc] = bk;
      ib->data[nib - 1] = ibfirst + 1;
      iblast = b_iblast + 1;
      ibfirst = b_iblast;
    }
  }

  while (ialast <= na) {
    iafirst = ialast;
    ak = skip_to_last_equal_value(&iafirst, a);
    nc++;
    nia++;
    c->data[nc] = ak;
    ia->data[nia] = ialast;
    ialast = iafirst + 1;
  }

  while (iblast <= nb) {
    iafirst = iblast;
    bk = skip_to_last_equal_value(&iafirst, b);
    nc++;
    nib++;
    c->data[nc] = bk;
    ib->data[nib - 1] = iblast;
    iblast = iafirst + 1;
  }

  if (a->size[0] > 0) {
    if (1 > nia + 1) {
      iafirst = -1;
    } else {
      iafirst = nia;
    }

    emxInit_int32_T(&b_ia, 1);
    ibfirst = b_ia->size[0];
    b_ia->size[0] = iafirst + 1;
    emxEnsureCapacity((emxArray__common *)b_ia, ibfirst, sizeof(int));
    for (ibfirst = 0; ibfirst <= iafirst; ibfirst++) {
      b_ia->data[ibfirst] = ia->data[ibfirst];
    }

    ibfirst = ia->size[0];
    ia->size[0] = b_ia->size[0];
    emxEnsureCapacity((emxArray__common *)ia, ibfirst, sizeof(int));
    iafirst = b_ia->size[0];
    for (ibfirst = 0; ibfirst < iafirst; ibfirst++) {
      ia->data[ibfirst] = b_ia->data[ibfirst];
    }

    emxFree_int32_T(&b_ia);
  }

  if (b->size[0] > 0) {
    if (1 > nib) {
      iafirst = 0;
    } else {
      iafirst = nib;
    }

    emxInit_int32_T(&b_ib, 1);
    ibfirst = b_ib->size[0];
    b_ib->size[0] = iafirst;
    emxEnsureCapacity((emxArray__common *)b_ib, ibfirst, sizeof(int));
    for (ibfirst = 0; ibfirst < iafirst; ibfirst++) {
      b_ib->data[ibfirst] = ib->data[ibfirst];
    }

    ibfirst = ib->size[0];
    ib->size[0] = b_ib->size[0];
    emxEnsureCapacity((emxArray__common *)ib, ibfirst, sizeof(int));
    iafirst = b_ib->size[0];
    for (ibfirst = 0; ibfirst < iafirst; ibfirst++) {
      ib->data[ibfirst] = b_ib->data[ibfirst];
    }

    emxFree_int32_T(&b_ib);
  }

  if (ncmax > 0) {
    if (1 > nc + 1) {
      iafirst = -1;
    } else {
      iafirst = nc;
    }

    emxInit_real_T1(&b_c, 1);
    ibfirst = b_c->size[0];
    b_c->size[0] = iafirst + 1;
    emxEnsureCapacity((emxArray__common *)b_c, ibfirst, sizeof(double));
    for (ibfirst = 0; ibfirst <= iafirst; ibfirst++) {
      b_c->data[ibfirst] = c->data[ibfirst];
    }

    ibfirst = c->size[0];
    c->size[0] = b_c->size[0];
    emxEnsureCapacity((emxArray__common *)c, ibfirst, sizeof(double));
    iafirst = b_c->size[0];
    for (ibfirst = 0; ibfirst < iafirst; ibfirst++) {
      c->data[ibfirst] = b_c->data[ibfirst];
    }

    emxFree_real_T(&b_c);
  }
}

/*
 * File trailer for eml_setop.c
 *
 * [EOF]
 */
