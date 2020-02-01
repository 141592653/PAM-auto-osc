/// @file
///	@ingroup 	minexamples
///	@copyright	Copyright 2018 The Min-DevKit Authors. All rights reserved.
///	@license	Use of this source code is governed by the MIT License found in the License.md file.

#include "c74_min.h"
#include <complex>
#include <array>

using namespace c74::min;

#define DEFAULT_PRESSURE_RATIO 0.8
#define DEFAULT_REED_OPENING 0.6
#define DEFAULT_RESONATOR_LENGTH 0.5
#define DEFAULT_DISSIPATION 0.3


#define COMPUTATION_DEPTH 2
#define EPSILON 0.0000001

#define SOUND_SPEED 340.
#define ZC 1.

#ifndef M_PI
# define M_PI 3.14159265358979323846
#endif // !M_PI


inline double LengthToTime(double length) {
	return 2. * length / SOUND_SPEED;
}

class schumaClarinet : public object<schumaClarinet>, public sample_operator<1, 1> {
private:
	double delta_t;
	std::array<double, COMPUTATION_DEPTH> F;
	std::array<double, COMPUTATION_DEPTH> Q;

public:
	MIN_DESCRIPTION{ "A modal model of a clarinet" };
	MIN_TAGS{ "simulation, clarinet" };
	MIN_AUTHOR{ "Alice Rixte" };
	MIN_RELATED{ "" };

	schumaClarinet(const atoms& args = {}) {
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
				dissipation = static_cast<double>(args[1]);
			}
			else
				dissipation = DEFAULT_DISSIPATION;
			resonator_time = LengthToTime(static_cast<double>(args[0]));
		}

		else
			resonator_time = LengthToTime(DEFAULT_RESONATOR_LENGTH);


		//Initialisation
		delta_t = 1. / samplerate();
		for (int i = 0; i < COMPUTATION_DEPTH; i++) {
			F[i] = 1.;
			Q[i] = (i + 1) / pow(10, -(i + 1));
		}
	}


	inlet<>  in_length{ this, "(signal) Length","signal" };
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

	attribute<number> pressure_ratio{ this, "pressure_ratio", DEFAULT_PRESSURE_RATIO,
		description {"Pressure inside the mouth compared to the pressure needed to close the reed"},
		setter { MIN_FUNCTION {
			
			return args;
		}} };

	attribute<number> reed_opening{ this, "reed_opening", DEFAULT_REED_OPENING,
		description {"Describes how the clarinet gives the air way"},
		setter { MIN_FUNCTION {
			return args;
		}} };


	attribute<number> resonator_time{ this, "resonator_time", DEFAULT_RESONATOR_LENGTH ,
	
		description {"Time for the sound to go back and forth in the resonator" },
		setter { MIN_FUNCTION {
			return args;
		}} };

	attribute<number> dissipation{ this, "dissipation", DEFAULT_DISSIPATION,
	description {"How much dissipation in the reflexion function."},
	setter { MIN_FUNCTION {
		return args;
	}} };


	message<> m_number{ this, "number", "Set the frequency in Hz.", MIN_FUNCTION {
		switch (inlet) {
		case 0:
			resonator_time = LengthToTime(static_cast<double>(args[0]));
			break;
		case 1:
			dissipation = args;
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

	sample operator()(sample a_length) {
		return a_length;
	}
};

MIN_EXTERNAL(schumaClarinet);
