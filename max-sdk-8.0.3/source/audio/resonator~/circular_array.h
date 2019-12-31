#pragma once
#include "ext.h"		// standard Max include
#include "ext_obex.h"	// required for "new" (Max 4.5 and later) style objects
#include "z_dsp.h"		// required for audio objects

typedef struct _circular_array {
	int size;
	int last;
	t_double* data;
} circularArray;

circularArray* newCircularArray(const int size);
void freeCircularArray(circularArray* circular_array);
void appendArray(circularArray* circular_array, const int size_of_append_array, const t_double* append_array);
void getEndArray(t_double* recieving_array, const circularArray* circular_array, const int size_of_end);