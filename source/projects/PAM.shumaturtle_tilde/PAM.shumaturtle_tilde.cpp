/// @file
///	@ingroup 	minexamples
///	@copyright	Copyright 2018 The Min-DevKit Authors. All rights reserved.
///	@license	Use of this source code is governed by the MIT License found in the License.md file.


#include "c74_min.h"

#include <cmath>
#include <complex>
#include <vector>
#include <array>
#include <algorithm>
#include <numeric>

#include "trapeze.h"
#include <gsl/gsl_poly.h>
#include <gsl/gsl_complex.h>


// TODO forbid too long resonators

using namespace c74::min;

#define DEFAULT_PRESSURE_RATIO 0.8
#define DEFAULT_REED_OPENING 0.8
#define DEFAULT_RESONATOR_LENGTH 0.3
#define DEFAULT_DISSIPATION 0.3


#define REFLEXION_SIZE 64 //optimal quality 64 => frequency max : ~
#define MEMORY_SIZE 1024 //  1024 -> max resonator length : 3.5 meters

#define EPSILON 0.0000001

#define SOUND_SPEED 340.
#define ZC 1.

#ifndef M_PI
# define M_PI 3.14159265358979323846
#endif // !M_PI

enum Excitator
{
	LippalReed, ClarinetReed, ClarinetReedSimplified, Violin
};

#define DEFAULT_EXCITATOR ClarinetReedSimplified



double exponentialR(const double t, std::vector<double> args) {
	return t < 0 ? 0 : exp(-args[0] * pow(t - args[1], 2));
}


class schumaClarinet : public object<schumaClarinet>, public sample_operator<1, 1> {
private:
	double dissipation;
	double delta_t;
	int offset;
	double a;
	double b;
	std::array<double, MEMORY_SIZE> F;
	std::array<double, MEMORY_SIZE> Q;
	std::array<double, REFLEXION_SIZE> R;

	Excitator excitator;

	//polynom coefficients
	double a_gamma;
	double b_gamma;
	double c_gamma;
	double abc_zeta;

	double zc_inv_sqr;

	void updateDissipation() {
		//update b
		b = log(2.) * pow(2. / (dissipation * resonator_time), 2);

		//update a
		double tmp = 2. * sqrt(1. / (2. * b));
		std::vector<double> v{ b,resonator_time };
		a = -1 / trapeze(exponentialR, resonator_time - tmp,
			resonator_time + tmp, 1000, v);
	}

	inline double LengthToTime(double length) {
		if (length < 0)
			cerr << "A length can't be negative. Taking the absolute value." << endl;
		return 2. * length / SOUND_SPEED;
	}



	double function_to_zero(double q, double qh) {
		return reed_opening*(1 - pressure_ratio + q) * sqrt(std::abs(pressure_ratio- q)) *\
			(pressure_ratio - q >=0. ? 1. : -1.) - q + qh;
	}

	double f_of_q(double q) {
		return reed_opening* (1 - pressure_ratio + q)* sqrt(std::abs(pressure_ratio - q))* \
			(pressure_ratio - q >= 0. ? 1. : -1.);
	}


public:
	MIN_DESCRIPTION{ "A modal model of a clarinet" };
	MIN_TAGS{ "simulation, clarinet" };
	MIN_AUTHOR{ "Alice Rixte" };
	MIN_RELATED{ "" };

	schumaClarinet(const atoms& args = {}) {

		if (args.size() >= 1)
			resonator_time = LengthToTime(static_cast<double>(args[0]));
		else
			resonator_time = LengthToTime(DEFAULT_RESONATOR_LENGTH);
		if (args.size() >= 2)
			dissipation = static_cast<double>(args[1]);
		else
			dissipation = DEFAULT_DISSIPATION;
		if (args.size() >= 3)
			pressure_ratio = static_cast<double>(args[2]);
		else
			pressure_ratio = DEFAULT_PRESSURE_RATIO;
		if (args.size() >= 4)
			reed_opening = static_cast<double>(args[3]);
		else
			reed_opening = DEFAULT_REED_OPENING;



		//Initialisation
		delta_t = 1. / samplerate();
		zc_inv_sqr = 1. / (ZC * ZC);
		updateDissipation();
		cout << a << " " << b << endl;

		F[0] = 1;
		F[1] = 0;
		Q[0] = 0.1;
		Q[1] = 0.11;
		int n = REFLEXION_SIZE;
		while (n--) {
			//TODO init R
		}
		R[0] = -1.;

	}


	inlet<>  in_length{ this, "(signal) Length","signal" };
	inlet<>  in_dissipation{ this, "(number) How much dissipation in the reflexion function." };
	inlet<>  in_pressure{ this, "(number) Pressure inside the mouth compared to the pressure needed to close the reed" };
	inlet<>  in_opening{ this, "(number) Describes how the clarinet gives the air way " };
	outlet<> out1{ this, "(signal) clarinet sound", "signal" };



	argument<number> length_arg{
		this, "resonator_length", "Initial length of the clarinet" };

	argument<number> dissipation_arg{
		this, "quality_factor", "Initial dissipation in the reflexion function." };

	argument<number> pressure_arg{
		this, "pressure_ratio", "Initial initial mouth pressure ratio" };

	argument<number> reed_opening_arg{
		this, "reed_opening", "Initial reed opening" };

	attribute<double> pressure_ratio{ this, "pressure_ratio", DEFAULT_PRESSURE_RATIO,
		description {"Pressure inside the mouth compared to the pressure needed to close the reed"},
		setter { MIN_FUNCTION {
			double gamma = static_cast<double>(args[0]);
			a_gamma = 3 * gamma - 2;
			b_gamma = (1 - gamma) * (3 * gamma - 1);
			c_gamma = pow(1 - gamma, 2) * gamma;
			return args;
		}} };

	attribute<number> reed_opening{ this, "reed_opening", DEFAULT_REED_OPENING,
		description {"Describes how the clarinet gives the air way"},
		setter { MIN_FUNCTION {
			double zeta_sqr = 
			abc_zeta =  1 / pow(static_cast<double>(args[0]) * ZC ,2); 
			return args;
		}} };



	attribute<number> resonator_time{ this, "resonator_time", LengthToTime(DEFAULT_RESONATOR_LENGTH) ,

		description {"Time for the sound to go back and forth in the resonator" },
		setter { MIN_FUNCTION {
			double new_T = static_cast<double>(args[0]);
			offset = floor(new_T * samplerate());
			if (offset >= MEMORY_SIZE) {
				cerr << "The resonator length is too long for the memory size. The sound will be degraded." << endl;
			}
			else if (offset < REFLEXION_SIZE) {
				cerr << "The resonator length is to short compared to the quality of the reflexion. The quality is lowered." << endl;
			}
			updateDissipation();
			return args;
		}} };


	message<> m_number{ this, "number", "Set the frequency in Hz.", MIN_FUNCTION {
		switch (inlet) {
		case 0:
			resonator_time = LengthToTime(static_cast<double>(args[0]));
			break;
		case 1:
			dissipation = static_cast<double>(args[0]);
			updateDissipation();
			break;
		case 2:
			pressure_ratio = args;
			break;
		case 3:
			reed_opening = args;
			break;
		case 4 : 
			excitator = static_cast<Excitator>(args[0]);
		default:
			std::cerr << "A number message has be sent to an unknown inlet" << std::endl;
	}
	return {};
	} };

	sample operator()(sample a_length) {

		//maybe store it
		int convolve_size = std::min(REFLEXION_SIZE, offset + 1);

		/*** Compute qh ***/
		double qh = 0;
		int i = 1;
		for (int i = 1; i < convolve_size - 1; i++) {
			qh += R[i] * (Q[offset - i] + ZC * F[offset - i]);
		}
		qh *= 2;
		qh += R[convolve_size - 1] * \
			(Q[offset - convolve_size + 1] + ZC * F[offset - convolve_size + 1]);
		qh += R.front() * (Q[offset] + ZC * F[offset]);


		gsl_complex z;
		GSL_SET_COMPLEX(&z, 0, 0);
		std::vector<double> roots(6);
		int nb_root1 = gsl_poly_solve_cubic(-a_gamma + abc_zeta,  -b_gamma - 2*qh*abc_zeta, -c_gamma + qh * qh * abc_zeta,
			&roots[0], &roots[1], &roots[2]);
		int nb_root2 = gsl_poly_solve_cubic(-a_gamma-abc_zeta,  -b_gamma + 2*qh*abc_zeta, -c_gamma - qh * qh * abc_zeta,
			&roots[3], &roots[4], &roots[5]);

		roots.erase(roots.begin() + 3 + nb_root2, roots.end());
		roots.erase(roots.begin() + nb_root1, roots.begin() + 3);

		
		i = roots.size();
		while (i>nb_root1) { //process the second roots
			i--;
			if (roots[i] < pressure_ratio)
				roots.erase(roots.begin() + i, roots.begin() + i +1);
		}
		while (i--) { //process the first roots
			if (roots[i] >= pressure_ratio)
				roots.erase(roots.begin() + i, roots.begin() + i + 1);
		}

		i = roots.size();
		while (i--) {
			double truc = function_to_zero(roots[i], qh);
			if (std::abs(truc)> sqrt(EPSILON) ||
				roots[i]<= pressure_ratio - 1)
				roots.erase(roots.begin() + i, roots.begin() + i + 1);
		}

		if (qh <= pressure_ratio - 1)
			roots.push_back(qh);

		double q = 0;
		if (roots.size()) {
			if (roots.size() == 1)
				q = roots[0];
			else {
				std::sort(roots.begin(), roots.end());
				if (roots.size() == 3)
					roots.erase(roots.begin() + 1, roots.begin() + 2);
				if (std::abs(roots[0] - Q[0]) < std::abs(roots[1] - Q[0]))
					q = roots[0];
				else
					q = roots[1];
			}
		}

		//!!!!!!!!!!!!!!!!!!!!!! Do I have to put that?
		//qh *= delta_t / 2;

		/*** Update Q and F ***/
		std::rotate(Q.rbegin(), Q.rbegin() + 1, Q.rend());
		std::rotate(F.rbegin(), F.rbegin() + 1, F.rend());
		Q[0] = q;
		F[0] = f_of_q(q);
		return q;
	}
};

MIN_EXTERNAL(schumaClarinet);

