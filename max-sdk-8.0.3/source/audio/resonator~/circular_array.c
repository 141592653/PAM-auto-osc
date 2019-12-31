#include "circular_array.h"

circularArray* newCircularArray(const int size) {
	circularArray new_array;
	new_array.size = size;
	new_array.last = 0;
	new_array.data = calloc(new_array.size, sizeof(double));
	return &new_array;

}

void freeCircularArray(circularArray* to_free) {
	free(to_free->data);
}


void getEndArray(t_double* recieving_array, const circularArray* circular_array, const int size_of_end) {
	for (int i = 0; i < size_of_end; i++) {
		recieving_array[i] = circular_array->data[(i + circular_array->last) % circular_array->size];
	}
}

void appendArray(circularArray* circular_array, const int size_of_append_array, const t_double* append_array) {
	for (int i = 0; i < size_of_append_array; i++) {
		circular_array->data[(i + circular_array->last) % circular_array->size] = append_array[i];
	}
	circular_array->last = (circular_array->last + size_of_append_array) % circular_array->size;

}