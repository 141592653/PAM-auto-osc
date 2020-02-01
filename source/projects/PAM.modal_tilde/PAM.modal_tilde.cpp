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




enum class operations : int { collect, average, product, enum_count };
enum_map operations_range = { "collect", "average", "product" };


class modalClarinet : public object<modalClarinet>, public sample_operator<1, 1> {
private:

	double A_gamma;
	double B_gamma;
	double C_gamma;
	double u0_gamma;
	double omega_L;
	double F1_L;
	double dt;

	std::complex<double> s1_Q;
	std::complex<double> C1_Q;

	std::complex<double> p_previous;


public:
	MIN_DESCRIPTION{ "A modal model of a clarinet" };
	MIN_TAGS{ "simulation, clarinet" };
	MIN_AUTHOR{ "Alice Rixte" };
	MIN_RELATED{ "" };

	modalClarinet(const atoms& args = {}) {
		if (args.size() >= 1) {
			if (args.size() >= 2) {
				if (args.size() >= 3) {
					if (args.size() >= 4) {
						reed_opening = static_cast<double>(args[3]);
					}
					else
						reed_opening = DEFAULT_REED_OPENING;
					pressure_ratio = static_cast<double>(args[2]);
				}
				else
					pressure_ratio = DEFAULT_PRESSURE_RATIO;
				quality_factor = static_cast<double>(args[1]);
			}
			else
				quality_factor = DEFAULT_QUALITY_FACT;
			resonator_length = static_cast<double>(args[0]);
		}

		else
			resonator_length = DEFAULT_RESONATOR_LENGTH;

		p_previous = 0.;
		dt = 1 / samplerate();
	}


	inlet<>  in_length{ this, "(signal) Length" };
	inlet<>  in_quality{ this, "(number) Quality factor of the resonator" };
	inlet<>  in_pressure{ this, "(number) Pressure inside the mouth compared to the pressure needed to close the reed" };
	inlet<>  in_opening{ this, "(number) Describes how the clarinet gives the air way " };
	outlet<> out1{ this, "(signal) clarinet sound", "signal" };

	argument<number> length_arg{
		this, "resonator_length", "Initial length of the clarinet" };

	argument<number> quality_arg{
		this, "quality_factor", "Initial quality factor of the resonator" };

	argument<number> pressure_arg{
		this, "pressure_ratio", "Initial initial mouth pressure ratio" };

	argument<number> reed_opening_arg{
		this, "reed_opening", "Initial reed opening" };

	attribute<operations> operation{ this, "operation", operations::collect, operations_range,
	description {"Choose the operation to perform with the input. Collect items into a list or calculate the mean "
				"from a list."} };

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
			F1_L = 2 * SOUND_SPEED / static_cast<double>(args[0]);
			omega_L = M_PI * F1_L / 8;
			return args;
		}} };

	attribute<double> quality_factor{ this, "quality_factor", DEFAULT_QUALITY_FACT,
	description {"Quality factor of the resonator"},
	setter { MIN_FUNCTION {
		double new_Q = static_cast<double>(args[0]);
		std::complex<double> sqrt_Q = sqrt(4 * pow(new_Q, 2) - 1.);
		s1_Q = new_Q * (I * sqrt_Q - static_cast<std::complex<double>>(1));
		C1_Q = static_cast<std::complex<double>>(1) + I / sqrt_Q;
		return args;
	}} };

	attribute<number> frequency_ratios{ this, "frequency_ratios", DEFAULT_QUALITY_FACT,
	description {"Frequency ratios of all the modes of the resonator"},
	setter { MIN_FUNCTION {
		return args;
	}} };


	message<> m_number{ this, "number", "Set the frequency in Hz.", MIN_FUNCTION {
		switch (inlet) {
		case 0:
			resonator_length = args;
			break;
		case 1:
			quality_factor = args;
			break;
		case 2:
			pressure_ratio = args;
			break;
		case 3:
			reed_opening = args;
			break;
		default:
			std::cerr << "A number message has be sent to an unknown inlet" << std::endl;
	}
	return {};
	} };

	message<> list{ this, "list", "Operate on the list. Either add it to the collection or calculate the mean.", MIN_FUNCTION{
		cout << (double)args[0] << " " << (double)args[1] << " " << (double)args[2] << endl;
		return {};
	}};
		

	sample operator()(sample a_length) {
		if (in_length.has_signal_connection())
			resonator_length = a_length;
		double pr = 2 * p_previous.real();
		double u = reed_opening * (u0_gamma + pr * (A_gamma + pr * (B_gamma + pr * C_gamma)));

		p_previous = (p_previous + dt * F1_L * C1_Q * u) / (static_cast<std::complex<double>>(1) - dt * omega_L * s1_Q);

		return p_previous.real();
	}
};

MIN_EXTERNAL(modalClarinet);
