/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 * File: main.c
 *
 * MATLAB Coder version            : 3.3
 * C/C++ source code generated on  : 06-Aug-2017 13:49:30
 */

/*************************************************************************/
/* This automatically generated example C main file shows how to call    */
/* entry-point functions that MATLAB Coder generated. You must customize */
/* this file for your application. Do not modify this file directly.     */
/* Instead, make a copy of this file, modify it, and integrate it into   */
/* your development environment.                                         */
/*                                                                       */
/* This file initializes entry-point function arguments to a default     */
/* size and value before calling the entry-point functions. It does      */
/* not store or use any values returned from the entry-point functions.  */
/* If necessary, it does pre-allocate memory for returned values.        */
/* You can use this file as a starting point for a main function that    */
/* you can deploy in your application.                                   */
/*                                                                       */
/* After you copy the file, and before you deploy it, you must make the  */
/* following changes:                                                    */
/* * For variable-size function arguments, change the example sizes to   */
/* the sizes that your application requires.                             */
/* * Change the example values of function arguments to the values that  */
/* your application requires.                                            */
/* * If the entry-point functions return values, store these values or   */
/* otherwise use them as required by your application.                   */
/*                                                                       */
/*************************************************************************/
/* Include Files */
#include "rt_nonfinite.h"
#include "link_trajectories3D.h"
#include "main.h"
#include "link_trajectories3D_terminate.h"
#include "link_trajectories3D_emxAPI.h"
#include "link_trajectories3D_initialize.h"

/* Function Declarations */
static cell_wrap_0 argInit_cell_wrap_0(void);
static double argInit_real_T(void);
static emxArray_cell_wrap_0 *c_argInit_UnboundedxUnbounded_c(void);
static emxArray_real_T *c_argInit_UnboundedxUnbounded_r(void);
static void main_link_trajectories3D(void);

/* Function Definitions */

/*
 * Arguments    : void
 * Return Type  : cell_wrap_0
 */
static cell_wrap_0 argInit_cell_wrap_0(void)
{
  cell_wrap_0 result;

  /* Set the value of each structure field.
     Change this value to the value that the application requires. */
  result.f1 = c_argInit_UnboundedxUnbounded_r();
  return result;
}

/*
 * Arguments    : void
 * Return Type  : double
 */
static double argInit_real_T(void)
{
  return 0.0;
}

/*
 * Arguments    : void
 * Return Type  : emxArray_cell_wrap_0 *
 */
static emxArray_cell_wrap_0 *c_argInit_UnboundedxUnbounded_c(void)
{
  emxArray_cell_wrap_0 *result;
  static int iv0[2] = { 2, 2 };

  int idx0;
  int idx1;

  /* Set the size of the array.
     Change this size to the value that the application requires. */
  result = emxCreateND_cell_wrap_0(2, iv0);

  /* Loop over the array to initialize each element. */
  for (idx0 = 0; idx0 < result->size[0U]; idx0++) {
    for (idx1 = 0; idx1 < result->size[1U]; idx1++) {
      /* Set the value of the array element.
         Change this value to the value that the application requires. */
      result->data[idx0 + result->size[0] * idx1] = argInit_cell_wrap_0();
    }
  }

  return result;
}

/*
 * Arguments    : void
 * Return Type  : emxArray_real_T *
 */
static emxArray_real_T *c_argInit_UnboundedxUnbounded_r(void)
{
  emxArray_real_T *result;
  static int iv1[2] = { 2, 2 };

  int idx0;
  int idx1;

  /* Set the size of the array.
     Change this size to the value that the application requires. */
  result = emxCreateND_real_T(2, iv1);

  /* Loop over the array to initialize each element. */
  for (idx0 = 0; idx0 < result->size[0U]; idx0++) {
    for (idx1 = 0; idx1 < result->size[1U]; idx1++) {
      /* Set the value of the array element.
         Change this value to the value that the application requires. */
      result->data[idx0 + result->size[0] * idx1] = argInit_real_T();
    }
  }

  return result;
}

/*
 * Arguments    : void
 * Return Type  : void
 */
static void main_link_trajectories3D(void)
{
  emxArray_cell_wrap_0 *peaks;

  /* Initialize function 'link_trajectories3D' input arguments. */
  /* Initialize function input argument 'peaks'. */
  peaks = c_argInit_UnboundedxUnbounded_c();

  /* Call the entry-point 'link_trajectories3D'. */
  link_trajectories3D(peaks, argInit_real_T());
  emxDestroyArray_cell_wrap_0(peaks);
}

/*
 * Arguments    : int argc
 *                const char * const argv[]
 * Return Type  : int
 */
int main(int argc, const char * const argv[])
{
  (void)argc;
  (void)argv;

  /* Initialize the application.
     You do not need to do this more than one time. */
  link_trajectories3D_initialize();

  /* Invoke the entry-point functions.
     You can call entry-point functions multiple times. */
  main_link_trajectories3D();

  /* Terminate the application.
     You do not need to do this more than one time. */
  link_trajectories3D_terminate();
  return 0;
}

/*
 * File trailer for main.c
 *
 * [EOF]
 */
