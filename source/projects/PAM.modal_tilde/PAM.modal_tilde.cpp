/// @file
///	@ingroup 	minexamples
///	@copyright	Copyright 2018 The Min-DevKit Authors. All rights reserved.
///	@license	Use of this source code is governed by the MIT License found in the License.md file.

#include "c74_min.h"
#include <complex>
#include <vector>

using namespace c74::min;
using namespace c74::min::lib;

#define DEFAULT_PRESSURE_RATIO 0.8
#define DEFAULT_REED_OPENING 0.6
#define DEFAULT_RESONATOR_LENGTH 0.5
#define DEFAULT_QUALITY_FACT 1
#define SOUND_SPEED 340.
#ifndef I
#define I std::complex<double>(0.0,1.0)
#endif

#ifndef M_PI
#define M_PI 3.14159265358979323846
#endif // !M_PI

enum Excitator
{
	LippalReed = 0, ClarinetReed = 1, ClarinetReedSimplified = 2, Violin = 3
};

#define DEFAULT_EXCITATOR ClarinetReedSimplified




std::complex<double> s1_Q_transform(double q) {
	return (1 / (2 * q)) * std::complex<double>(-1, sqrt(4. * pow(q, 2) - 1.));
};

std::complex<double> C1_Q_transform(double q) {
	return (1 / q) * std::complex<double>(1,1/sqrt(4. * pow(q, 2) - 1.));
};

double sign(double a) {
	return a >= 0. ? 1. : -1.;
}


class modalClarinet : public object<modalClarinet>, public sample_operator<1, 1> {
private:

	double A_gamma;
	double B_gamma;
	double C_gamma;
	double u0_gamma;
	double omega_L;
	double freq_L;
	double dt;

	std::vector<double> Z;
	//std::vector<double> Q;
	std::vector<double> freq_ratio;
	Excitator excitator;

	std::vector<std::complex<double>> s1_Q;
	std::vector<std::complex<double>> C1_Q;



	double x,x_prev;
	std::vector<std::complex<double>> p;
	double p_prev;

	void update_Q(std::vector<double> new_Q) {
		for (int i = 0; i < new_Q.size();i++) {
			s1_Q[i] = s1_Q_transform(new_Q[i]);
			C1_Q[i] = C1_Q_transform(new_Q[i]);
		}
	}



public:
	MIN_DESCRIPTION{ "A modal model of a clarinet" };
	MIN_TAGS{ "simulation, clarinet" };
	MIN_AUTHOR{ "Alice Rixte" };
	MIN_RELATED{ "" };

	modalClarinet(const atoms& args = {}) {
		if (args.size() >= 1)
			resonator_length = static_cast<double>(args[0]);
		else
			resonator_length = DEFAULT_RESONATOR_LENGTH;
		/*if (args.size() >= 2) 
			quality_factor = static_cast<double>(args[1]);
		else
			quality_factor = DEFAULT_QUALITY_FACT;*/
		if (args.size() >= 3) 
			pressure_ratio = static_cast<double>(args[2]);
		else
			pressure_ratio = DEFAULT_PRESSURE_RATIO;
		if (args.size() >= 4) 
			reed_opening = static_cast<double>(args[3]);
		else
			reed_opening = DEFAULT_REED_OPENING;
		if (args.size() >= 5)
			excitator = static_cast<Excitator>(args[4]);
		else
			excitator = DEFAULT_EXCITATOR;

		freq_ratio.resize(2);
		freq_ratio[0] = 1.;
		freq_ratio[1] = 2.;

		Z.resize(2);
		Z[0] = 10;
		Z[1] = 7.5;
		p.resize(freq_ratio.size());
		p[0] = 0.;
		p[1] = 0.;
		freq_ratio[1] = 2.;
		//initial conditions
		p_prev = 0;
		dt = 1 / samplerate();
		s1_Q.resize(freq_ratio.size());
		C1_Q.resize(freq_ratio.size());

		std::vector<double> Q_init({ 10., 15.});
		update_Q(Q_init);
	}


	inlet<>  in_length{ this, "(signal) Length" };
	inlet<>  in_quality{ this, "(number) Quality factor of the resonator" };
	inlet<>  in_pressure{ this, "(number) Pressure inside the mouth compared to the pressure needed to close the reed" };
	inlet<>  in_opening{ this, "(number) Describes how the clarinet gives the air way " };
	inlet<>  in_excitator{ this, "(int) Excitator type : LippalReed = 0, ClarinetReed = 1, ClarinetReedSimplified = 2, Violin = 3" };
	outlet<> out1{ this, "(signal) clarinet sound", "signal" };

	argument<number> length_arg{
		this, "resonator_length", "Initial length of the clarinet" };

	argument<number> quality_arg{
		this, "quality_factor", "Initial quality factor of the resonator" };

	argument<number> pressure_arg{
		this, "pressure_ratio", "Initial initial mouth pressure ratio" };

	argument<number> reed_opening_arg{
		this, "reed_opening", "Initial reed opening" };


	attribute<number> pressure_ratio{ this, "pressure_ratio", DEFAULT_PRESSURE_RATIO,
		description {"Pressure inside the mouth compared to the pressure needed to close the reed"},
		setter { MIN_FUNCTION {
			double new_gamma = static_cast<double>(args[0]);
			double sqr_gamma = sqrt(new_gamma);
			A_gamma = (3. * new_gamma - 1.) / (2. * sqr_gamma);
			B_gamma = -(3. * new_gamma + 1.) / (8. * pow(sqr_gamma,3));
			C_gamma = -(new_gamma + 1.) / (16. * pow(sqr_gamma,5));
			u0_gamma = (1 - new_gamma) * sqr_gamma;

			return args;
		}} };

	attribute<number> reed_opening{ this, "reed_opening", DEFAULT_REED_OPENING,
		description {"Describes how the clarinet gives the air way"},
		setter { MIN_FUNCTION {
			return args;
		}} };


	attribute<number> resonator_length{ this, "resonator_length", DEFAULT_RESONATOR_LENGTH ,

		description {"Length of the clarinet"},
		setter { MIN_FUNCTION {
			freq_L =  SOUND_SPEED / (2 * static_cast<double>(args[0]));
			omega_L = 2 * M_PI * freq_L ;
			return args;
		}} };

	/*attribute<numbers> quality_factors{ this, "quality factors", DEFAULT_RESONATOR_LENGTH ,

		description {"Length of the clarinet"},setter { MIN_FUNCTION {
		std::vector<std::complex<double>> new_Q = static_cast<std::vector<std::complex<double>>>(args[0]);
		std::transform(std::begin(new_Q), std::end(new_Q), std::begin(s1_Q), s1_Q_transform);
		std::transform(std::begin(new_Q), std::end(new_Q), std::begin(C1_Q), C1_Q_transform);
		//std::complex<double> sqrt_Q = sqrt(4 * pow(new_Q, 2) - 1.);
		//s1_Q = new_Q * (I * sqrt_Q - static_cast<std::complex<double>>(1));
		//C1_Q = static_cast<std::complex<double>>(1) + I / sqrt_Q;
		return args;
	}} };*/


	message<> m_number{ this, "number", "Set the frequency in Hz.", MIN_FUNCTION {
		switch (inlet) {
		case 0:
			resonator_length = args;
			break;
		case 1:
		{
			std::vector<double> new_Q;
			for (int i = 0; i < new_Q.size(); i++) {
				new_Q.push_back(static_cast<double>(args[i]));
			}
			update_Q(new_Q);
			//quality_factor = args;
		}
			break;
		case 2:
			pressure_ratio = args;
			break;
		case 3:
			reed_opening = args;
			break;
		case 4:
			excitator = static_cast<Excitator>(args[0]);
		default:
			std::cerr << "A number message has be sent to an unknown inlet" << std::endl;
	}
	return {};
	} };

	message<> list{ this, "list", "Operate on the list. Either add it to the collection or calculate the mean.", MIN_FUNCTION{
		cout << (double)args[0] << " " << (double)args[1] << " " << (double)args[2] << endl;
		return {};
	} };


	sample operator()(sample a_length) {
		if (in_length.has_signal_connection())
			resonator_length = a_length;
		double pr = 2 * p_prev;
		double u = 0; 

		switch (excitator) {
		case ClarinetReed : 
			if (pressure_ratio - pr < 1)
				u = reed_opening *(1 - pressure_ratio + pr)*sqrt(abs(pressure_ratio - pr))*sign(pressure_ratio - pr);
			break;
		case ClarinetReedSimplified : 
			u = reed_opening* (u0_gamma + pr * (A_gamma + pr * (B_gamma + pr * C_gamma)));
			break;
		case LippalReed :
			double next_x_prev = x;
			//x = (-pr - 1 / wr / wr * (x_prev - 2 * x) / dt / dt + qr / wr * x / dt) / (1 / (wr * dt) ^ 2 + qr / (wr * dt) + 1);
			//u(i) = zeta.*(1 + gamma + x(i)).*sqrt(abs(gamma - pr)).*sign(gamma - pr);
		}

		p_prev = 0.;
		for (int i = 0; i < p.size(); i++) {
			std::complex<double> chose = dt * omega_L * Z[i] * freq_ratio[i] * C1_Q[i] * u;
			std::complex<double> chose2 = (static_cast<std::complex<double>>(1) - dt * freq_ratio[i] * omega_L * s1_Q[i]);

			p[i] = (p[i] + dt * omega_L * Z[i] * freq_ratio[i] * C1_Q[i] * u) / 
				(static_cast<std::complex<double>>(1) - dt * freq_ratio[i] * omega_L* s1_Q[i]);
			p_prev += p[i].real();
		}


		// OPTI : just sum real parts with accumulate
		//std::complex<double> p_prev_complex = std::accumulate(std::begin(p), std::end(p), 0, std::plus<std::complex<double>>());
		//p_prev = p_prev_complex.real();
		return p_prev;
	}
};

MIN_EXTERNAL(modalClarinet);
