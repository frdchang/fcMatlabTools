/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * link_trajectories3D.c
 *
 * Code generation for function 'link_trajectories3D'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "link_trajectories3D.h"
#include "ifWhileCond.h"
#include "link_trajectories3D_emxutil.h"
#include "sum.h"
#include "find.h"
#include "sort1.h"
#include "eml_setop.h"
#include "repmat.h"
#include "power.h"

/* Function Declarations */
static int div_s32(int numerator, int denominator);

/* Function Definitions */
static int div_s32(int numerator, int denominator)
{
  int quotient;
  unsigned int absNumerator;
  unsigned int absDenominator;
  boolean_T quotientNeedsNegation;
  if (denominator == 0) {
    if (numerator >= 0) {
      quotient = MAX_int32_T;
    } else {
      quotient = MIN_int32_T;
    }
  } else {
    if (numerator < 0) {
      absNumerator = ~(unsigned int)numerator + 1U;
    } else {
      absNumerator = (unsigned int)numerator;
    }

    if (denominator < 0) {
      absDenominator = ~(unsigned int)denominator + 1U;
    } else {
      absDenominator = (unsigned int)denominator;
    }

    quotientNeedsNegation = ((numerator < 0) != (denominator < 0));
    absNumerator /= absDenominator;
    if (quotientNeedsNegation) {
      quotient = -(int)absNumerator;
    } else {
      quotient = (int)absNumerator;
    }
  }

  return quotient;
}

void link_trajectories3D(emxArray_cell_wrap_0 *peaks, double L)
{
  int n;
  int iframe;
  emxArray_real_T *A;
  emxArray_real_T *xrep;
  emxArray_real_T *yrep;
  emxArray_real_T *zrep;
  emxArray_real_T *dm0;
  emxArray_real_T *s;
  emxArray_int32_T *dumidx;
  emxArray_real_T *Cred;
  emxArray_int32_T *Xcand;
  emxArray_int32_T *Ycand;
  emxArray_real_T *Jlink;
  emxArray_real_T *b_s;
  emxArray_real_T *r0;
  emxArray_real_T *r1;
  emxArray_real_T *r2;
  emxArray_int32_T *r3;
  emxArray_boolean_T *x;
  emxArray_int32_T *ii;
  emxArray_int32_T *b_ii;
  emxArray_int32_T *ib;
  emxArray_int32_T *vk;
  emxArray_int32_T *c_ii;
  emxArray_real_T *d_ii;
  emxArray_real_T *e_ii;
  emxArray_real_T *b_zrep;
  emxArray_real_T *c_zrep;
  emxArray_real_T *b_xrep;
  emxArray_real_T *b_peaks;
  emxArray_real_T *c_peaks;
  emxArray_real_T *c_xrep;
  emxArray_real_T *d_peaks;
  emxArray_real_T *e_peaks;
  emxArray_real_T *d_zrep;
  emxArray_real_T *b_yrep;
  emxArray_real_T *d_xrep;
  emxArray_real_T *f_peaks;
  emxArray_real_T *g_peaks;
  emxArray_real_T *h_peaks;
  emxArray_real_T *i_peaks;
  emxArray_real_T *j_peaks;
  emxArray_real_T *k_peaks;
  emxArray_boolean_T *r4;
  emxArray_real_T *b_A;
  emxArray_boolean_T *c_s;
  emxArray_real_T *f_ii;
  emxArray_real_T *g_ii;
  emxArray_boolean_T *c_A;
  emxArray_boolean_T *d_A;
  emxArray_int32_T *d_s;
  int nx;
  int i0;
  int varargin_1;
  int b_varargin_1;
  int i1;
  int finished;
  double iidx;
  int jj;
  int ixstart;
  int loop_ub;
  int b_loop_ub;
  int idx;
  int h_ii;
  boolean_T exitg1;
  int siz[2];
  int exitg2;
  boolean_T guard1 = false;
  boolean_T b0;
  unsigned int siz_idx_0;

  /* ====================================================================== */
  /*  */
  /*  LINK_TRAJECTORIES: links particle positions into trajectories */
  /*  */
  /*  SYNTAX:  peaks = link_trajectories(peaks, L, viz, nfig) */
  /*  */
  /*  INPUTS:  peaks     peaks cell list of particle positions in all */
  /*                     frames and zero and second order intensity */
  /*                     moments as produced by detect_particles */
  /*           L         maximum allowed particle displacement between */
  /*                     two subsequent frames (cutoff) */
  /*           viz       =1 if intermediate visualization is needed */
  /*           nfig      figure number for first viz image */
  /*  */
  /*  The particle matching is done such that the sum of squared */
  /*  displacements between two frames in minimized and also the */
  /*  quadratic differences in the zero and second order intensity */
  /*  moments of the particles are minimizes (more precise: between */
  /*  the particle properties peaks{i}(:,3) and peaks{i}(:,4)). */
  /*  */
  /*  After linkage, the same cell list "peaks" is returned but with */
  /*  the fields peaks{i}(:,6) now filled. All other fields are left */
  /*  untouched. peaks{i}(j,6) contains the index of the one */
  /*  particle in frame i+1 corresponding to particle j in frame i. */
  /*  If no correspondence was found (i.e. the trajectory terminates) */
  /*  -1 is given. */
  /*  */
  /*  Ivo Sbalzarini, 12.2.2003 */
  /*  Institute of Computational Science, Swiss Federal */
  /*  Institute of Technology (ETH) Zurich. */
  /*  E-mail: sbalzarini@inf.ethz.ch */
  /*  */
  /*  Based on the logistic transportation algorithm described in: */
  /*      http://www.damtp.cam.ac.uk/user/fdl/people/sd/digimage/... */
  /*         document/track2d/matching.htm#L_2_PARTICLE_MATCHING */
  /* ====================================================================== */
  /* ====================================================================== */
  /*  STEP 5: Linking locations into trajectories */
  /* ====================================================================== */
  if ((peaks->size[0] == 0) || (peaks->size[1] == 0)) {
    n = -1;
  } else if (peaks->size[0] > peaks->size[1]) {
    n = peaks->size[0] - 1;
  } else {
    n = peaks->size[1] - 1;
  }

  iframe = 0;
  emxInit_real_T(&A, 2);
  emxInit_real_T(&xrep, 2);
  emxInit_real_T(&yrep, 2);
  emxInit_real_T(&zrep, 2);
  emxInit_real_T(&dm0, 2);
  emxInit_real_T1(&s, 1);
  emxInit_int32_T1(&dumidx, 2);
  emxInit_real_T1(&Cred, 1);
  emxInit_int32_T(&Xcand, 1);
  emxInit_int32_T(&Ycand, 1);
  emxInit_real_T1(&Jlink, 1);
  emxInit_real_T(&b_s, 2);
  emxInit_real_T(&r0, 2);
  emxInit_real_T(&r1, 2);
  emxInit_real_T(&r2, 2);
  emxInit_int32_T1(&r3, 2);
  emxInit_boolean_T(&x, 2);
  emxInit_int32_T(&ii, 1);
  emxInit_int32_T(&b_ii, 1);
  emxInit_int32_T(&ib, 1);
  emxInit_int32_T(&vk, 1);
  emxInit_int32_T1(&c_ii, 2);
  emxInit_real_T1(&d_ii, 1);
  emxInit_real_T1(&e_ii, 1);
  emxInit_real_T1(&b_zrep, 1);
  emxInit_real_T(&c_zrep, 2);
  emxInit_real_T(&b_xrep, 2);
  emxInit_real_T1(&b_peaks, 1);
  emxInit_real_T(&c_peaks, 2);
  emxInit_real_T(&c_xrep, 2);
  emxInit_real_T1(&d_peaks, 1);
  emxInit_real_T(&e_peaks, 2);
  emxInit_real_T(&d_zrep, 2);
  emxInit_real_T(&b_yrep, 2);
  emxInit_real_T(&d_xrep, 2);
  emxInit_real_T1(&f_peaks, 1);
  emxInit_real_T1(&g_peaks, 1);
  emxInit_real_T1(&h_peaks, 1);
  emxInit_real_T(&i_peaks, 2);
  emxInit_real_T(&j_peaks, 2);
  emxInit_real_T(&k_peaks, 2);
  emxInit_boolean_T(&r4, 2);
  emxInit_real_T1(&b_A, 1);
  emxInit_boolean_T(&c_s, 2);
  emxInit_real_T1(&f_ii, 1);
  emxInit_real_T1(&g_ii, 1);
  emxInit_boolean_T1(&c_A, 1);
  emxInit_boolean_T(&d_A, 2);
  emxInit_int32_T1(&d_s, 2);
  while (iframe <= (int)((double)(n + 1) + -1.0) - 1) {
    /*  initialize all linked lists to -1 */
    nx = peaks->data[(int)((2.0 + (double)iframe) - 1.0) - 1].f1->size[0];
    for (i0 = 0; i0 < nx; i0++) {
      peaks->data[(int)((2.0 + (double)iframe) - 1.0) - 1].f1->data[i0 +
        peaks->data[(int)((2.0 + (double)iframe) - 1.0) - 1].f1->size[0] * 5] =
        -1.0;
    }

    varargin_1 = peaks->data[(int)((2.0 + (double)iframe) - 1.0) - 1].f1->size[0];
    i0 = peaks->data[(int)((2.0 + (double)iframe) - 1.0) - 1].f1->size[0];

    /*  previous frame: p_i, i=1,..,m */
    b_varargin_1 = peaks->data[iframe + 1].f1->size[0];
    i1 = peaks->data[iframe + 1].f1->size[0];

    /*  this frame: q_j, j=1,..,n */
    /*  empty association matrix */
    finished = A->size[0] * A->size[1];
    A->size[0] = varargin_1 + 1;
    A->size[1] = b_varargin_1 + 1;
    emxEnsureCapacity((emxArray__common *)A, finished, sizeof(double));
    nx = (varargin_1 + 1) * (b_varargin_1 + 1);
    for (finished = 0; finished < nx; finished++) {
      A->data[finished] = 0.0;
    }

    /*  a_{ij}=1 <=> p_i = q_j */
    /*  dummy particles a_{(m+1)j}, */
    /*  a_{i(n+1)} */
    /*  delta(i,j): quadratic distance between p_i and q_j */
    nx = peaks->data[iframe + 1].f1->size[0];
    finished = k_peaks->size[0] * k_peaks->size[1];
    k_peaks->size[0] = 1;
    k_peaks->size[1] = nx;
    emxEnsureCapacity((emxArray__common *)k_peaks, finished, sizeof(double));
    for (finished = 0; finished < nx; finished++) {
      k_peaks->data[k_peaks->size[0] * finished] = peaks->data[iframe + 1]
        .f1->data[finished];
    }

    repmat(k_peaks, varargin_1, xrep);
    nx = peaks->data[iframe + 1].f1->size[0];
    finished = j_peaks->size[0] * j_peaks->size[1];
    j_peaks->size[0] = 1;
    j_peaks->size[1] = nx;
    emxEnsureCapacity((emxArray__common *)j_peaks, finished, sizeof(double));
    for (finished = 0; finished < nx; finished++) {
      j_peaks->data[j_peaks->size[0] * finished] = peaks->data[iframe + 1]
        .f1->data[finished + peaks->data[iframe + 1].f1->size[0]];
    }

    repmat(j_peaks, varargin_1, yrep);
    nx = peaks->data[iframe + 1].f1->size[0];
    finished = i_peaks->size[0] * i_peaks->size[1];
    i_peaks->size[0] = 1;
    i_peaks->size[1] = nx;
    emxEnsureCapacity((emxArray__common *)i_peaks, finished, sizeof(double));
    for (finished = 0; finished < nx; finished++) {
      i_peaks->data[i_peaks->size[0] * finished] = peaks->data[iframe + 1]
        .f1->data[finished + (peaks->data[iframe + 1].f1->size[0] << 1)];
    }

    repmat(i_peaks, varargin_1, zrep);
    nx = peaks->data[(int)((2.0 + (double)iframe) - 1.0) - 1].f1->size[0];
    finished = h_peaks->size[0];
    h_peaks->size[0] = nx;
    emxEnsureCapacity((emxArray__common *)h_peaks, finished, sizeof(double));
    for (finished = 0; finished < nx; finished++) {
      h_peaks->data[finished] = peaks->data[(int)((2.0 + (double)iframe) - 1.0)
        - 1].f1->data[finished];
    }

    b_repmat(h_peaks, b_varargin_1, r0);
    nx = peaks->data[(int)((2.0 + (double)iframe) - 1.0) - 1].f1->size[0];
    finished = g_peaks->size[0];
    g_peaks->size[0] = nx;
    emxEnsureCapacity((emxArray__common *)g_peaks, finished, sizeof(double));
    for (finished = 0; finished < nx; finished++) {
      g_peaks->data[finished] = peaks->data[(int)((2.0 + (double)iframe) - 1.0)
        - 1].f1->data[finished + peaks->data[(int)((2.0 + (double)iframe) - 1.0)
        - 1].f1->size[0]];
    }

    b_repmat(g_peaks, b_varargin_1, r1);
    nx = peaks->data[(int)((2.0 + (double)iframe) - 1.0) - 1].f1->size[0];
    finished = f_peaks->size[0];
    f_peaks->size[0] = nx;
    emxEnsureCapacity((emxArray__common *)f_peaks, finished, sizeof(double));
    for (finished = 0; finished < nx; finished++) {
      f_peaks->data[finished] = peaks->data[(int)((2.0 + (double)iframe) - 1.0)
        - 1].f1->data[finished + (peaks->data[(int)((2.0 + (double)iframe) - 1.0)
        - 1].f1->size[0] << 1)];
    }

    b_repmat(f_peaks, b_varargin_1, r2);
    finished = d_xrep->size[0] * d_xrep->size[1];
    d_xrep->size[0] = xrep->size[0];
    d_xrep->size[1] = xrep->size[1];
    emxEnsureCapacity((emxArray__common *)d_xrep, finished, sizeof(double));
    nx = xrep->size[0] * xrep->size[1];
    for (finished = 0; finished < nx; finished++) {
      d_xrep->data[finished] = xrep->data[finished] - r0->data[finished];
    }

    power(d_xrep, r0);
    finished = b_yrep->size[0] * b_yrep->size[1];
    b_yrep->size[0] = yrep->size[0];
    b_yrep->size[1] = yrep->size[1];
    emxEnsureCapacity((emxArray__common *)b_yrep, finished, sizeof(double));
    nx = yrep->size[0] * yrep->size[1];
    for (finished = 0; finished < nx; finished++) {
      b_yrep->data[finished] = yrep->data[finished] - r1->data[finished];
    }

    power(b_yrep, r1);
    finished = d_zrep->size[0] * d_zrep->size[1];
    d_zrep->size[0] = zrep->size[0];
    d_zrep->size[1] = zrep->size[1];
    emxEnsureCapacity((emxArray__common *)d_zrep, finished, sizeof(double));
    nx = zrep->size[0] * zrep->size[1];
    for (finished = 0; finished < nx; finished++) {
      d_zrep->data[finished] = zrep->data[finished] - r2->data[finished];
    }

    power(d_zrep, r2);

    /*  dm0(i,j): quadratic difference between m0 moments of p_i and q_j */
    nx = peaks->data[iframe + 1].f1->size[0];
    finished = e_peaks->size[0] * e_peaks->size[1];
    e_peaks->size[0] = 1;
    e_peaks->size[1] = nx;
    emxEnsureCapacity((emxArray__common *)e_peaks, finished, sizeof(double));
    for (finished = 0; finished < nx; finished++) {
      e_peaks->data[e_peaks->size[0] * finished] = peaks->data[iframe + 1]
        .f1->data[finished + peaks->data[iframe + 1].f1->size[0] * 3];
    }

    repmat(e_peaks, varargin_1, xrep);
    nx = peaks->data[(int)((2.0 + (double)iframe) - 1.0) - 1].f1->size[0];
    finished = d_peaks->size[0];
    d_peaks->size[0] = nx;
    emxEnsureCapacity((emxArray__common *)d_peaks, finished, sizeof(double));
    for (finished = 0; finished < nx; finished++) {
      d_peaks->data[finished] = peaks->data[(int)((2.0 + (double)iframe) - 1.0)
        - 1].f1->data[finished + peaks->data[(int)((2.0 + (double)iframe) - 1.0)
        - 1].f1->size[0] * 3];
    }

    b_repmat(d_peaks, b_varargin_1, yrep);
    finished = c_xrep->size[0] * c_xrep->size[1];
    c_xrep->size[0] = xrep->size[0];
    c_xrep->size[1] = xrep->size[1];
    emxEnsureCapacity((emxArray__common *)c_xrep, finished, sizeof(double));
    nx = xrep->size[0] * xrep->size[1];
    for (finished = 0; finished < nx; finished++) {
      c_xrep->data[finished] = xrep->data[finished] - yrep->data[finished];
    }

    power(c_xrep, dm0);

    /*  dm2(i,j): quadratic difference between m2 moments of p_i and q_j */
    nx = peaks->data[iframe + 1].f1->size[0];
    finished = c_peaks->size[0] * c_peaks->size[1];
    c_peaks->size[0] = 1;
    c_peaks->size[1] = nx;
    emxEnsureCapacity((emxArray__common *)c_peaks, finished, sizeof(double));
    for (finished = 0; finished < nx; finished++) {
      c_peaks->data[c_peaks->size[0] * finished] = peaks->data[iframe + 1]
        .f1->data[finished + (peaks->data[iframe + 1].f1->size[0] << 2)];
    }

    repmat(c_peaks, varargin_1, xrep);
    nx = peaks->data[(int)((2.0 + (double)iframe) - 1.0) - 1].f1->size[0];
    finished = b_peaks->size[0];
    b_peaks->size[0] = nx;
    emxEnsureCapacity((emxArray__common *)b_peaks, finished, sizeof(double));
    for (finished = 0; finished < nx; finished++) {
      b_peaks->data[finished] = peaks->data[(int)((2.0 + (double)iframe) - 1.0)
        - 1].f1->data[finished + (peaks->data[(int)((2.0 + (double)iframe) - 1.0)
        - 1].f1->size[0] << 2)];
    }

    b_repmat(b_peaks, b_varargin_1, yrep);
    finished = b_xrep->size[0] * b_xrep->size[1];
    b_xrep->size[0] = xrep->size[0];
    b_xrep->size[1] = xrep->size[1];
    emxEnsureCapacity((emxArray__common *)b_xrep, finished, sizeof(double));
    nx = xrep->size[0] * xrep->size[1];
    for (finished = 0; finished < nx; finished++) {
      b_xrep->data[finished] = xrep->data[finished] - yrep->data[finished];
    }

    power(b_xrep, yrep);

    /*  C(i,j): cost function for link p_i, q_j */
    iidx = L * L;
    finished = peaks->data[(int)((2.0 + (double)iframe) - 1.0) - 1].f1->size[0]
      + 1;
    jj = peaks->data[iframe + 1].f1->size[0] + 1;
    ixstart = zrep->size[0] * zrep->size[1];
    zrep->size[0] = finished;
    zrep->size[1] = jj;
    emxEnsureCapacity((emxArray__common *)zrep, ixstart, sizeof(double));
    nx = finished * jj;
    for (finished = 0; finished < nx; finished++) {
      zrep->data[finished] = iidx;
    }

    /*  set broken dummy links to L^2 */
    nx = r0->size[1];
    for (finished = 0; finished < nx; finished++) {
      ixstart = r0->size[0];
      for (jj = 0; jj < ixstart; jj++) {
        zrep->data[jj + zrep->size[0] * finished] = (((r0->data[jj + r0->size[0]
          * finished] + r1->data[jj + r1->size[0] * finished]) + r2->data[jj +
          r2->size[0] * finished]) + dm0->data[jj + dm0->size[0] * finished]) +
          yrep->data[jj + yrep->size[0] * finished];
      }
    }

    /*  set cost of matchings that will never occur to Inf */
    if (1 > varargin_1) {
      nx = 0;
    } else {
      nx = varargin_1;
    }

    if (1 > b_varargin_1) {
      ixstart = 0;
      loop_ub = 0;
    } else {
      ixstart = b_varargin_1;
      loop_ub = b_varargin_1;
    }

    finished = c_zrep->size[0] * c_zrep->size[1];
    c_zrep->size[0] = 1;
    c_zrep->size[1] = loop_ub;
    emxEnsureCapacity((emxArray__common *)c_zrep, finished, sizeof(double));
    for (finished = 0; finished < loop_ub; finished++) {
      c_zrep->data[c_zrep->size[0] * finished] = zrep->data[varargin_1 +
        zrep->size[0] * finished];
    }

    repmat(c_zrep, varargin_1, r0);
    if (1 > varargin_1) {
      loop_ub = 0;
    } else {
      loop_ub = varargin_1;
    }

    if (1 > b_varargin_1) {
      b_loop_ub = 0;
    } else {
      b_loop_ub = b_varargin_1;
    }

    if (1 > varargin_1) {
      jj = 0;
    } else {
      jj = varargin_1;
    }

    finished = b_zrep->size[0];
    b_zrep->size[0] = jj;
    emxEnsureCapacity((emxArray__common *)b_zrep, finished, sizeof(double));
    for (finished = 0; finished < jj; finished++) {
      b_zrep->data[finished] = zrep->data[finished + zrep->size[0] *
        b_varargin_1];
    }

    b_repmat(b_zrep, b_varargin_1, r1);
    finished = x->size[0] * x->size[1];
    x->size[0] = nx;
    x->size[1] = ixstart;
    emxEnsureCapacity((emxArray__common *)x, finished, sizeof(boolean_T));
    for (finished = 0; finished < ixstart; finished++) {
      for (jj = 0; jj < nx; jj++) {
        x->data[jj + x->size[0] * finished] = (zrep->data[jj + zrep->size[0] *
          finished] - r0->data[jj + r0->size[0] * finished] > 0.0);
      }
    }

    nx = x->size[0] * x->size[1];
    idx = 0;
    finished = ii->size[0];
    ii->size[0] = nx;
    emxEnsureCapacity((emxArray__common *)ii, finished, sizeof(int));
    h_ii = 1;
    exitg1 = false;
    while ((!exitg1) && (h_ii <= nx)) {
      if (x->data[h_ii - 1]) {
        idx++;
        ii->data[idx - 1] = h_ii;
        if (idx >= nx) {
          exitg1 = true;
        } else {
          h_ii++;
        }
      } else {
        h_ii++;
      }
    }

    if (nx == 1) {
      if (idx == 0) {
        finished = ii->size[0];
        ii->size[0] = 0;
        emxEnsureCapacity((emxArray__common *)ii, finished, sizeof(int));
      }
    } else {
      finished = ii->size[0];
      if (1 > idx) {
        ii->size[0] = 0;
      } else {
        ii->size[0] = idx;
      }

      emxEnsureCapacity((emxArray__common *)ii, finished, sizeof(int));
    }

    finished = x->size[0] * x->size[1];
    x->size[0] = loop_ub;
    x->size[1] = b_loop_ub;
    emxEnsureCapacity((emxArray__common *)x, finished, sizeof(boolean_T));
    for (finished = 0; finished < b_loop_ub; finished++) {
      for (jj = 0; jj < loop_ub; jj++) {
        x->data[jj + x->size[0] * finished] = (zrep->data[jj + zrep->size[0] *
          finished] - r1->data[jj + r1->size[0] * finished] > 0.0);
      }
    }

    nx = x->size[0] * x->size[1];
    idx = 0;
    finished = b_ii->size[0];
    b_ii->size[0] = nx;
    emxEnsureCapacity((emxArray__common *)b_ii, finished, sizeof(int));
    h_ii = 1;
    exitg1 = false;
    while ((!exitg1) && (h_ii <= nx)) {
      if (x->data[h_ii - 1]) {
        idx++;
        b_ii->data[idx - 1] = h_ii;
        if (idx >= nx) {
          exitg1 = true;
        } else {
          h_ii++;
        }
      } else {
        h_ii++;
      }
    }

    if (nx == 1) {
      if (idx == 0) {
        finished = b_ii->size[0];
        b_ii->size[0] = 0;
        emxEnsureCapacity((emxArray__common *)b_ii, finished, sizeof(int));
      }
    } else {
      finished = b_ii->size[0];
      if (1 > idx) {
        b_ii->size[0] = 0;
      } else {
        b_ii->size[0] = idx;
      }

      emxEnsureCapacity((emxArray__common *)b_ii, finished, sizeof(int));
    }

    finished = d_ii->size[0];
    d_ii->size[0] = ii->size[0];
    emxEnsureCapacity((emxArray__common *)d_ii, finished, sizeof(double));
    nx = ii->size[0];
    for (finished = 0; finished < nx; finished++) {
      d_ii->data[finished] = ii->data[finished];
    }

    finished = e_ii->size[0];
    e_ii->size[0] = b_ii->size[0];
    emxEnsureCapacity((emxArray__common *)e_ii, finished, sizeof(double));
    nx = b_ii->size[0];
    for (finished = 0; finished < nx; finished++) {
      e_ii->data[finished] = b_ii->data[finished];
    }

    do_vectors(d_ii, e_ii, s, vk, ib);
    finished = b_ii->size[0];
    b_ii->size[0] = s->size[0];
    emxEnsureCapacity((emxArray__common *)b_ii, finished, sizeof(int));
    nx = s->size[0];
    for (finished = 0; finished < nx; finished++) {
      b_ii->data[finished] = (int)s->data[finished];
    }

    finished = b_ii->size[0];
    emxEnsureCapacity((emxArray__common *)b_ii, finished, sizeof(int));
    nx = b_ii->size[0];
    for (finished = 0; finished < nx; finished++) {
      b_ii->data[finished]--;
    }

    finished = vk->size[0];
    vk->size[0] = b_ii->size[0];
    emxEnsureCapacity((emxArray__common *)vk, finished, sizeof(int));
    nx = b_ii->size[0];
    for (finished = 0; finished < nx; finished++) {
      vk->data[finished] = div_s32(b_ii->data[finished], varargin_1);
    }

    finished = b_ii->size[0];
    emxEnsureCapacity((emxArray__common *)b_ii, finished, sizeof(int));
    nx = b_ii->size[0];
    for (finished = 0; finished < nx; finished++) {
      b_ii->data[finished] -= vk->data[finished] * varargin_1;
    }

    finished = s->size[0];
    s->size[0] = b_ii->size[0];
    emxEnsureCapacity((emxArray__common *)s, finished, sizeof(double));
    nx = b_ii->size[0];
    for (finished = 0; finished < nx; finished++) {
      s->data[finished] = b_ii->data[finished] + 1;
    }

    finished = Jlink->size[0];
    Jlink->size[0] = vk->size[0];
    emxEnsureCapacity((emxArray__common *)Jlink, finished, sizeof(double));
    nx = vk->size[0];
    for (finished = 0; finished < nx; finished++) {
      Jlink->data[finished] = vk->data[finished] + 1;
    }

    for (finished = 0; finished < 2; finished++) {
      siz[finished] = zrep->size[finished];
    }

    finished = b_ii->size[0];
    b_ii->size[0] = s->size[0];
    emxEnsureCapacity((emxArray__common *)b_ii, finished, sizeof(int));
    nx = s->size[0];
    for (finished = 0; finished < nx; finished++) {
      b_ii->data[finished] = (int)s->data[finished] + siz[0] * ((int)Jlink->
        data[finished] - 1);
    }

    nx = b_ii->size[0];
    for (finished = 0; finished < nx; finished++) {
      zrep->data[b_ii->data[finished] - 1] = rtInf;
    }

    /*  initialize link matrix A */
    for (h_ii = 0; h_ii < i0; h_ii++) {
      /*  sort costs of real particles */
      nx = zrep->size[1];
      finished = b_s->size[0] * b_s->size[1];
      b_s->size[0] = 1;
      b_s->size[1] = nx;
      emxEnsureCapacity((emxArray__common *)b_s, finished, sizeof(double));
      for (finished = 0; finished < nx; finished++) {
        b_s->data[b_s->size[0] * finished] = zrep->data[h_ii + zrep->size[0] *
          finished];
      }

      sort(b_s, c_ii);
      finished = b_s->size[0] * b_s->size[1];
      b_s->size[0] = 1;
      b_s->size[1] = c_ii->size[1];
      emxEnsureCapacity((emxArray__common *)b_s, finished, sizeof(double));
      nx = c_ii->size[0] * c_ii->size[1];
      for (finished = 0; finished < nx; finished++) {
        b_s->data[finished] = c_ii->data[finished];
      }

      /*  append index of dummy particle */
      iidx = 1.0;
      finished = c_s->size[0] * c_s->size[1];
      c_s->size[0] = 1;
      c_s->size[1] = b_s->size[1];
      emxEnsureCapacity((emxArray__common *)c_s, finished, sizeof(boolean_T));
      nx = b_s->size[0] * b_s->size[1];
      for (finished = 0; finished < nx; finished++) {
        c_s->data[finished] = (b_s->data[finished] == (double)i1 + 1.0);
      }

      eml_find(c_s, c_ii);
      finished = dumidx->size[0] * dumidx->size[1];
      dumidx->size[0] = 1;
      dumidx->size[1] = c_ii->size[1];
      emxEnsureCapacity((emxArray__common *)dumidx, finished, sizeof(int));
      nx = c_ii->size[0] * c_ii->size[1];
      for (finished = 0; finished < nx; finished++) {
        dumidx->data[finished] = c_ii->data[finished];
      }

      /*  search for available particle of smallest cost or dummy */
      do {
        exitg2 = 0;
        nx = A->size[0];
        finished = d_s->size[0] * d_s->size[1];
        d_s->size[0] = 1;
        d_s->size[1] = b_s->size[1];
        emxEnsureCapacity((emxArray__common *)d_s, finished, sizeof(int));
        ixstart = b_s->size[1];
        for (finished = 0; finished < ixstart; finished++) {
          d_s->data[d_s->size[0] * finished] = (int)b_s->data[b_s->size[0] *
            finished];
        }

        jj = d_s->data[(int)iidx - 1];
        finished = b_A->size[0];
        b_A->size[0] = nx;
        emxEnsureCapacity((emxArray__common *)b_A, finished, sizeof(double));
        for (finished = 0; finished < nx; finished++) {
          b_A->data[finished] = A->data[finished + A->size[0] * (jj - 1)];
        }

        b0 = (sum(b_A) != 0.0);
        finished = r4->size[0] * r4->size[1];
        r4->size[0] = 1;
        r4->size[1] = dumidx->size[1];
        emxEnsureCapacity((emxArray__common *)r4, finished, sizeof(boolean_T));
        nx = dumidx->size[0] * dumidx->size[1];
        for (finished = 0; finished < nx; finished++) {
          r4->data[finished] = (b0 && (iidx < dumidx->data[finished]));
        }

        if (ifWhileCond(r4)) {
          iidx++;
        } else {
          exitg2 = 1;
        }
      } while (exitg2 == 0);

      A->data[h_ii + A->size[0] * ((int)b_s->data[(int)iidx - 1] - 1)] = 1.0;
    }

    /*  set dummy particle for columns with no entry */
    b_sum(A, b_s);
    jj = b_s->size[1] - 1;
    ixstart = 0;
    for (h_ii = 0; h_ii <= jj; h_ii++) {
      if (b_s->data[h_ii] < 1.0) {
        ixstart++;
      }
    }

    i0 = r3->size[0] * r3->size[1];
    r3->size[0] = 1;
    r3->size[1] = ixstart;
    emxEnsureCapacity((emxArray__common *)r3, i0, sizeof(int));
    ixstart = 0;
    for (h_ii = 0; h_ii <= jj; h_ii++) {
      if (b_s->data[h_ii] < 1.0) {
        r3->data[ixstart] = h_ii + 1;
        ixstart++;
      }
    }

    ixstart = r3->size[1];
    for (i0 = 0; i0 < ixstart; i0++) {
      A->data[varargin_1 + A->size[0] * (r3->data[r3->size[0] * i0] - 1)] = 1.0;
    }

    /*  dummy always corresponds to dummy */
    A->data[varargin_1 + A->size[0] * b_varargin_1] = 1.0;

    /*  consistency check for matrix A */
    /*  iteration loop for the logistic transportation algorithm */
    finished = 0;
    while (!(finished != 0)) {
      /*  non-set links of finite cost */
      if (1 > varargin_1) {
        nx = 0;
      } else {
        nx = varargin_1;
      }

      if (1 > b_varargin_1) {
        ixstart = 0;
      } else {
        ixstart = b_varargin_1;
      }

      if (1 > varargin_1) {
        loop_ub = 0;
      } else {
        loop_ub = varargin_1;
      }

      if (1 > b_varargin_1) {
        b_loop_ub = 0;
      } else {
        b_loop_ub = b_varargin_1;
      }

      i0 = x->size[0] * x->size[1];
      x->size[0] = nx;
      x->size[1] = ixstart;
      emxEnsureCapacity((emxArray__common *)x, i0, sizeof(boolean_T));
      for (i0 = 0; i0 < ixstart; i0++) {
        for (i1 = 0; i1 < nx; i1++) {
          x->data[i1 + x->size[0] * i0] = (A->data[i1 + A->size[0] * i0] == 0.0);
        }
      }

      nx = x->size[0] * x->size[1];
      idx = 0;
      i0 = ii->size[0];
      ii->size[0] = nx;
      emxEnsureCapacity((emxArray__common *)ii, i0, sizeof(int));
      h_ii = 1;
      exitg1 = false;
      while ((!exitg1) && (h_ii <= nx)) {
        if (x->data[h_ii - 1]) {
          idx++;
          ii->data[idx - 1] = h_ii;
          if (idx >= nx) {
            exitg1 = true;
          } else {
            h_ii++;
          }
        } else {
          h_ii++;
        }
      }

      if (nx == 1) {
        if (idx == 0) {
          i0 = ii->size[0];
          ii->size[0] = 0;
          emxEnsureCapacity((emxArray__common *)ii, i0, sizeof(int));
        }
      } else {
        i0 = ii->size[0];
        if (1 > idx) {
          ii->size[0] = 0;
        } else {
          ii->size[0] = idx;
        }

        emxEnsureCapacity((emxArray__common *)ii, i0, sizeof(int));
      }

      i0 = x->size[0] * x->size[1];
      x->size[0] = loop_ub;
      x->size[1] = b_loop_ub;
      emxEnsureCapacity((emxArray__common *)x, i0, sizeof(boolean_T));
      for (i0 = 0; i0 < b_loop_ub; i0++) {
        for (i1 = 0; i1 < loop_ub; i1++) {
          x->data[i1 + x->size[0] * i0] = (zrep->data[i1 + zrep->size[0] * i0] <
            rtInf);
        }
      }

      nx = x->size[0] * x->size[1];
      idx = 0;
      i0 = b_ii->size[0];
      b_ii->size[0] = nx;
      emxEnsureCapacity((emxArray__common *)b_ii, i0, sizeof(int));
      h_ii = 1;
      exitg1 = false;
      while ((!exitg1) && (h_ii <= nx)) {
        if (x->data[h_ii - 1]) {
          idx++;
          b_ii->data[idx - 1] = h_ii;
          if (idx >= nx) {
            exitg1 = true;
          } else {
            h_ii++;
          }
        } else {
          h_ii++;
        }
      }

      if (nx == 1) {
        if (idx == 0) {
          i0 = b_ii->size[0];
          b_ii->size[0] = 0;
          emxEnsureCapacity((emxArray__common *)b_ii, i0, sizeof(int));
        }
      } else {
        i0 = b_ii->size[0];
        if (1 > idx) {
          b_ii->size[0] = 0;
        } else {
          b_ii->size[0] = idx;
        }

        emxEnsureCapacity((emxArray__common *)b_ii, i0, sizeof(int));
      }

      i0 = f_ii->size[0];
      f_ii->size[0] = ii->size[0];
      emxEnsureCapacity((emxArray__common *)f_ii, i0, sizeof(double));
      nx = ii->size[0];
      for (i0 = 0; i0 < nx; i0++) {
        f_ii->data[i0] = ii->data[i0];
      }

      i0 = g_ii->size[0];
      g_ii->size[0] = b_ii->size[0];
      emxEnsureCapacity((emxArray__common *)g_ii, i0, sizeof(double));
      nx = b_ii->size[0];
      for (i0 = 0; i0 < nx; i0++) {
        g_ii->data[i0] = b_ii->data[i0];
      }

      b_do_vectors(f_ii, g_ii, s, vk, ib);

      /*  determine induced changes and reduced cost Cred for each */
      /*  candidate link insertion */
      i0 = b_ii->size[0];
      b_ii->size[0] = s->size[0];
      emxEnsureCapacity((emxArray__common *)b_ii, i0, sizeof(int));
      nx = s->size[0];
      for (i0 = 0; i0 < nx; i0++) {
        b_ii->data[i0] = (int)s->data[i0];
      }

      i0 = b_ii->size[0];
      emxEnsureCapacity((emxArray__common *)b_ii, i0, sizeof(int));
      nx = b_ii->size[0];
      for (i0 = 0; i0 < nx; i0++) {
        b_ii->data[i0]--;
      }

      i0 = vk->size[0];
      vk->size[0] = b_ii->size[0];
      emxEnsureCapacity((emxArray__common *)vk, i0, sizeof(int));
      nx = b_ii->size[0];
      for (i0 = 0; i0 < nx; i0++) {
        vk->data[i0] = div_s32(b_ii->data[i0], varargin_1);
      }

      i0 = b_ii->size[0];
      emxEnsureCapacity((emxArray__common *)b_ii, i0, sizeof(int));
      nx = b_ii->size[0];
      for (i0 = 0; i0 < nx; i0++) {
        b_ii->data[i0] -= vk->data[i0] * varargin_1;
      }

      i0 = s->size[0];
      s->size[0] = b_ii->size[0];
      emxEnsureCapacity((emxArray__common *)s, i0, sizeof(double));
      nx = b_ii->size[0];
      for (i0 = 0; i0 < nx; i0++) {
        s->data[i0] = b_ii->data[i0] + 1;
      }

      i0 = Jlink->size[0];
      Jlink->size[0] = vk->size[0];
      emxEnsureCapacity((emxArray__common *)Jlink, i0, sizeof(double));
      nx = vk->size[0];
      for (i0 = 0; i0 < nx; i0++) {
        Jlink->data[i0] = vk->data[i0] + 1;
      }

      siz_idx_0 = (unsigned int)s->size[0];
      i0 = Cred->size[0];
      Cred->size[0] = (int)siz_idx_0;
      emxEnsureCapacity((emxArray__common *)Cred, i0, sizeof(double));
      nx = (int)siz_idx_0;
      for (i0 = 0; i0 < nx; i0++) {
        Cred->data[i0] = 0.0;
      }

      siz_idx_0 = (unsigned int)s->size[0];
      i0 = Xcand->size[0];
      Xcand->size[0] = (int)siz_idx_0;
      emxEnsureCapacity((emxArray__common *)Xcand, i0, sizeof(int));
      nx = (int)siz_idx_0;
      for (i0 = 0; i0 < nx; i0++) {
        Xcand->data[i0] = 0;
      }

      siz_idx_0 = (unsigned int)s->size[0];
      i0 = Ycand->size[0];
      Ycand->size[0] = (int)siz_idx_0;
      emxEnsureCapacity((emxArray__common *)Ycand, i0, sizeof(int));
      nx = (int)siz_idx_0;
      for (i0 = 0; i0 < nx; i0++) {
        Ycand->data[i0] = 0;
      }

      for (ixstart = 0; ixstart < s->size[0]; ixstart++) {
        Cred->data[ixstart] = zrep->data[((int)s->data[ixstart] + zrep->size[0] *
          ((int)Jlink->data[ixstart] - 1)) - 1];
        nx = A->size[1];
        jj = (int)s->data[ixstart];
        i0 = d_A->size[0] * d_A->size[1];
        d_A->size[0] = 1;
        d_A->size[1] = nx;
        emxEnsureCapacity((emxArray__common *)d_A, i0, sizeof(boolean_T));
        for (i0 = 0; i0 < nx; i0++) {
          d_A->data[d_A->size[0] * i0] = (A->data[(jj + A->size[0] * i0) - 1] ==
            1.0);
        }

        eml_find(d_A, c_ii);
        Xcand->data[ixstart] = c_ii->data[0];
        nx = A->size[0];
        jj = (int)Jlink->data[ixstart];
        i0 = c_A->size[0];
        c_A->size[0] = nx;
        emxEnsureCapacity((emxArray__common *)c_A, i0, sizeof(boolean_T));
        for (i0 = 0; i0 < nx; i0++) {
          c_A->data[i0] = (A->data[i0 + A->size[0] * (jj - 1)] == 1.0);
        }

        b_eml_find(c_A, ii);
        Ycand->data[ixstart] = ii->data[0];
        Cred->data[ixstart] = (Cred->data[ixstart] - zrep->data[((int)s->
          data[ixstart] + zrep->size[0] * (Xcand->data[ixstart] - 1)) - 1]) -
          zrep->data[(Ycand->data[ixstart] + zrep->size[0] * ((int)Jlink->
          data[ixstart] - 1)) - 1];
        Cred->data[ixstart] += zrep->data[(Ycand->data[ixstart] + zrep->size[0] *
          (Xcand->data[ixstart] - 1)) - 1];
      }

      /*  find minimum cost and corresponding action */
      ixstart = 1;
      jj = Cred->size[0];
      iidx = Cred->data[0];
      loop_ub = 0;
      if (Cred->size[0] > 1) {
        if (rtIsNaN(Cred->data[0])) {
          h_ii = 1;
          exitg1 = false;
          while ((!exitg1) && (h_ii + 1 <= jj)) {
            ixstart = h_ii + 1;
            if (!rtIsNaN(Cred->data[h_ii])) {
              iidx = Cred->data[h_ii];
              loop_ub = h_ii;
              exitg1 = true;
            } else {
              h_ii++;
            }
          }
        }

        if (ixstart < Cred->size[0]) {
          while (ixstart + 1 <= jj) {
            if (Cred->data[ixstart] < iidx) {
              iidx = Cred->data[ixstart];
              loop_ub = ixstart;
            }

            ixstart++;
          }
        }
      }

      /*  if minimum is < 0, link addition is favorable */
      if (iidx < 0.0) {
        /*  add link and update dependencies to preserve topology */
        A->data[((int)s->data[loop_ub] + A->size[0] * ((int)Jlink->data[loop_ub]
                  - 1)) - 1] = 1.0;
        A->data[(Ycand->data[loop_ub] + A->size[0] * ((int)Jlink->data[loop_ub]
                  - 1)) - 1] = 0.0;
        A->data[((int)s->data[loop_ub] + A->size[0] * (Xcand->data[loop_ub] - 1))
          - 1] = 0.0;
        A->data[(Ycand->data[loop_ub] + A->size[0] * (Xcand->data[loop_ub] - 1))
          - 1] = 1.0;
      } else {
        /*  done if best change is no more an improvement */
        finished = 1;
      }

      /*  consistency check for matrix A */
    }

    /*  Convert link matrix to linked list representation */
    if (1 > varargin_1) {
      loop_ub = 0;
    } else {
      loop_ub = varargin_1;
    }

    i0 = A->size[1];
    nx = loop_ub * i0;
    idx = 0;
    i0 = ii->size[0];
    ii->size[0] = nx;
    emxEnsureCapacity((emxArray__common *)ii, i0, sizeof(int));
    i0 = b_ii->size[0];
    b_ii->size[0] = nx;
    emxEnsureCapacity((emxArray__common *)b_ii, i0, sizeof(int));
    ixstart = A->size[1];
    if (nx == 0) {
      i0 = ii->size[0];
      ii->size[0] = 0;
      emxEnsureCapacity((emxArray__common *)ii, i0, sizeof(int));
      i0 = b_ii->size[0];
      b_ii->size[0] = 0;
      emxEnsureCapacity((emxArray__common *)b_ii, i0, sizeof(int));
    } else {
      h_ii = 1;
      jj = 1;
      exitg1 = false;
      while ((!exitg1) && (jj <= ixstart)) {
        guard1 = false;
        if (A->data[(h_ii + A->size[0] * (jj - 1)) - 1] != 0.0) {
          idx++;
          ii->data[idx - 1] = h_ii;
          b_ii->data[idx - 1] = jj;
          if (idx >= nx) {
            exitg1 = true;
          } else {
            guard1 = true;
          }
        } else {
          guard1 = true;
        }

        if (guard1) {
          h_ii++;
          if (h_ii > loop_ub) {
            h_ii = 1;
            jj++;
          }
        }
      }

      if (nx == 1) {
        if (idx == 0) {
          i0 = ii->size[0];
          ii->size[0] = 0;
          emxEnsureCapacity((emxArray__common *)ii, i0, sizeof(int));
          i0 = b_ii->size[0];
          b_ii->size[0] = 0;
          emxEnsureCapacity((emxArray__common *)b_ii, i0, sizeof(int));
        }
      } else {
        i0 = ii->size[0];
        if (1 > idx) {
          ii->size[0] = 0;
        } else {
          ii->size[0] = idx;
        }

        emxEnsureCapacity((emxArray__common *)ii, i0, sizeof(int));
        i0 = b_ii->size[0];
        if (1 > idx) {
          b_ii->size[0] = 0;
        } else {
          b_ii->size[0] = idx;
        }

        emxEnsureCapacity((emxArray__common *)b_ii, i0, sizeof(int));
      }
    }

    i0 = s->size[0];
    s->size[0] = b_ii->size[0];
    emxEnsureCapacity((emxArray__common *)s, i0, sizeof(double));
    nx = b_ii->size[0];
    for (i0 = 0; i0 < nx; i0++) {
      s->data[i0] = b_ii->data[i0];
    }

    i0 = Jlink->size[0];
    Jlink->size[0] = s->size[0];
    emxEnsureCapacity((emxArray__common *)Jlink, i0, sizeof(double));
    nx = s->size[0];
    for (i0 = 0; i0 < nx; i0++) {
      Jlink->data[i0] = s->data[i0];
    }

    /*  if link is to dummy particle, set index to -1 */
    jj = s->size[0];
    for (h_ii = 0; h_ii < jj; h_ii++) {
      if (s->data[h_ii] == (double)b_varargin_1 + 1.0) {
        Jlink->data[h_ii] = -1.0;
      }
    }

    /*  set linked list indices */
    nx = Jlink->size[0];
    for (i0 = 0; i0 < nx; i0++) {
      peaks->data[(int)((2.0 + (double)iframe) - 1.0) - 1].f1->data[(ii->data[i0]
        + peaks->data[(int)((2.0 + (double)iframe) - 1.0) - 1].f1->size[0] * 5)
        - 1] = Jlink->data[i0];
    }

    iframe++;
  }

  emxFree_int32_T(&d_s);
  emxFree_boolean_T(&d_A);
  emxFree_boolean_T(&c_A);
  emxFree_real_T(&g_ii);
  emxFree_real_T(&f_ii);
  emxFree_boolean_T(&c_s);
  emxFree_real_T(&b_A);
  emxFree_boolean_T(&r4);
  emxFree_real_T(&k_peaks);
  emxFree_real_T(&j_peaks);
  emxFree_real_T(&i_peaks);
  emxFree_real_T(&h_peaks);
  emxFree_real_T(&g_peaks);
  emxFree_real_T(&f_peaks);
  emxFree_real_T(&d_xrep);
  emxFree_real_T(&b_yrep);
  emxFree_real_T(&d_zrep);
  emxFree_real_T(&e_peaks);
  emxFree_real_T(&d_peaks);
  emxFree_real_T(&c_xrep);
  emxFree_real_T(&c_peaks);
  emxFree_real_T(&b_peaks);
  emxFree_real_T(&b_xrep);
  emxFree_real_T(&c_zrep);
  emxFree_real_T(&b_zrep);
  emxFree_real_T(&e_ii);
  emxFree_real_T(&d_ii);
  emxFree_int32_T(&c_ii);
  emxFree_int32_T(&vk);
  emxFree_int32_T(&ib);
  emxFree_int32_T(&b_ii);
  emxFree_int32_T(&ii);
  emxFree_boolean_T(&x);
  emxFree_int32_T(&r3);
  emxFree_real_T(&r2);
  emxFree_real_T(&r1);
  emxFree_real_T(&r0);
  emxFree_real_T(&b_s);
  emxFree_real_T(&Jlink);
  emxFree_int32_T(&Ycand);
  emxFree_int32_T(&Xcand);
  emxFree_real_T(&Cred);
  emxFree_int32_T(&dumidx);
  emxFree_real_T(&s);
  emxFree_real_T(&dm0);
  emxFree_real_T(&zrep);
  emxFree_real_T(&yrep);
  emxFree_real_T(&xrep);
  emxFree_real_T(&A);

  /*  terminate all linked lists at the very end */
  nx = peaks->data[n].f1->size[0];
  for (i0 = 0; i0 < nx; i0++) {
    peaks->data[n].f1->data[i0 + peaks->data[n].f1->size[0] * 5] = -1.0;
  }
}

/* End of code generation (link_trajectories3D.c) */
