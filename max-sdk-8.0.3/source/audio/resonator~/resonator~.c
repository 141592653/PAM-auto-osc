/*
	split~: An audio version of the Max 'split' object
	Originally known as tap.split~, from Tap.Tools by Timothy Place
	Copyright 2011 Cycling '74
*/

#include "ext.h"		// standard Max include
#include "ext_obex.h"	// required for "new" (Max 4.5 and later) style objects
#include "z_dsp.h"		// required for audio objects
#include "circular_array.h"

#define C_SOUND 340.

// struct to represent the object's state
typedef struct _res {
	t_pxobject	s_ob;					// audio object "base class"
	double		s_length;				// low bound of the range

	int			s_r_size;				// length of the reflexion function
	double		s_r[1];					// the reflexion function 
	circularArray*	s_passed;				// keep some of the passed signal

	int			s_duration_size;		//duration of one travel in the resonator in sample
	bool		s_is_duration_allocated;
	circularArray* 	s_duration_res;
	
} t_res;


// method prototypes
void *res_new(t_symbol *msg, long argc, t_atom *argv);
void res_assist(t_res *x, void *b, long m, long a, char *s);
void res_int(t_res *x, long n);
void res_float(t_res *x, double val);
// (we can skip the prototypes for the perform methods; we'll define them in the body above the point where they are called)
void res_dsp64(t_res *x, t_object *dsp64, short *count, double samplerate, long maxvectorsize, long flags);


// global class pointer variable
static t_class *s_res_class = NULL;


//***********************************************************************************************

void ext_main(void *r)
{
	t_class *c = class_new("resonator~", (method)res_new, (method)dsp_free, sizeof(t_res), NULL, A_GIMME, 0);

	class_addmethod(c, (method)res_int,		"int",		A_LONG, 0);
	class_addmethod(c, (method)res_float,		"float",	A_FLOAT, 0);
	class_addmethod(c, (method)res_dsp64,		"dsp64",	A_CANT, 0);		// New 64-bit MSP dsp chain compilation for Max 6
	class_addmethod(c, (method)res_assist,	"assist",	A_CANT, 0);

	class_dspinit(c);
	class_register(CLASS_BOX, c);
	s_res_class = c;
}


void *res_new(t_symbol *s, long argc, t_atom *argv)
{
	t_res *x = (t_res *)object_alloc(s_res_class);

	if (x) {
		dsp_setup((t_pxobject *)x, 1);				// 1 inlets (input, low-value, high-value)
		outlet_new((t_object *)x, "signal");		// 1 outlet : other side of the resonator

		float length;
		atom_arg_getfloat(&length, 0, argc, argv);	// get typed in args
		x->s_length = length / 100.;

		x->s_r_size = 1;
		x->s_r[0] = 0.5;
		x->s_passed =  newCircularArray(x->s_r_size);

		x->s_length = 1.;
		x->s_is_duration_allocated = false;
		x->s_duration_size = 0;
	}
	return x;
}

void res_free(t_res* x) {
	dsp_free((t_pxobject*) x);
	freeCircularArray(x->s_passed);
	if (x->s_is_duration_allocated) {
		freeCircularArray(x->s_duration_res);
	}
}

//***********************************************************************************************

void res_assist(t_res *x, void *b, long msg, long arg, char *dst)
{
	if (msg == ASSIST_INLET) {
		switch (arg) {
		case 0: strcpy(dst, "(signal) Signal entering the resonator (float) Value of the length in cm."); break;
		}
	}
	else if (msg == ASSIST_OUTLET) {
		switch (arg) {
		case 0: strcpy(dst, "(signal) Signal at the open end of the resonator"); break;
		}
	}
}


void res_float(t_res *x, double value)
{
	long inlet_number = proxy_getinlet((t_object *)x);

	if (inlet_number == 0)
	{
		x->s_length = value / 100.;
		x->s_is_duration_allocated = false;
	}
	else
		object_error((t_object *)x, "oops -- maybe you sent a number to the wrong inlet?");
}


void res_int(t_res *x, long value)
{
	res_float(x, value);
}


//***********************************************************************************************

// We have 2 perform methods:
// One of the perform methods is for all 3 audio signals connected.
// The other perform method is optimized for the case where only the first audio signal is connected.


// Perform (signal) Method for 3 input signals, 64-bit MSP
void res_perform364(t_res *x, t_object *dsp64, double **ins, long numins, double **outs, long numouts, long sampleframes, long flags, void *userparam)
{
	t_double	*in1 = ins[0];		// Input 1
	t_double	*out1 = outs[0];	// Output 1

	int			n = sampleframes;
	t_double	value;

	getEndArray(out1, x->s_duration_res, sampleframes);
	for (int i; i < sampleframes; i++){
		x->s_duration_res->data[(i + x->s_duration_res->last) % x->s_duration_res->size] += 0.5 * out1[i];
	}
	appendArray(x->s_duration_res, sampleframes, in1);


}



int compute_res_duration(t_res* x, double samplerate) {
	return (int)( samplerate * x->s_length / C_SOUND);
}


//***********************************************************************************************

void res_dsp64(t_res *x, t_object *dsp64, short *count, double samplerate, long maxvectorsize, long flags)
{
	if (!x->s_is_duration_allocated) {
		x->s_duration_size = compute_res_duration(x, samplerate);
		x->s_duration_res = calloc(x->s_duration_size, sizeof(double));
		x->s_is_duration_allocated = true;
	}


	object_method(dsp64, gensym("dsp_add64"), x, res_perform364, 0, NULL);
}

