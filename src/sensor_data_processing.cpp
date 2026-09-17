#include <iostream>
#include <vector>
#include <cstdlib>
#include <ctime>
#include <unistd.h>

#define NUM_SENSORS 1000
#define READINGS_PER_SENSOR 100

int read_sensor_value(){
    return rand() % 1024;
}

std::vector<int>* generate_sensor_data(){
    std::vector<int>* readings = new std::vector<int>();

    for (int i = 0; i < READINGS_PER_SENSOR; ++i){
        readings->push_back(read_sensor_value());
    }

    return readings;
}

double calculate_average(std::vector<int>* data){
    double sum = 0;

    for (int i = 0; i < data->size(); ++i){
        sum += (*data)[i];
    }

    return sum / data->size();
}

int main()
{
    srand(time(0));

    std::vector<double> averages;

    for (int i = 0; i < NUM_SENSORS; ++i) {
        std::vector<int>* sensor_data = generate_sensor_data();

        double avg = calculate_average(sensor_data);

        averages.push_back(avg);

        usleep(1000);   // aproximadamente 1 ms
    }

    std::cout << "Processed data from "
              << NUM_SENSORS
              << " sensors.\n";

    return 0;
}