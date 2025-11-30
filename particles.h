#pragma once
#include <cuda_runtime.h>
#include <curand_kernel.h>
#include <iostream>

struct Particle {
    float3 pos;
    float3 vel;
    float mass;
};

// Inicializa partículas aleatórias na CPU
void initParticles(Particle* particles, int n) {
    for(int i = 0; i < n; i++) {
        particles[i].pos = make_float3((float)rand()/RAND_MAX*10.0f, 
                                       (float)rand()/RAND_MAX*10.0f, 
                                       (float)rand()/RAND_MAX*10.0f);
        particles[i].vel = make_float3(0,0,0);
        particles[i].mass = 1.0f + (float)rand()/RAND_MAX*4.0f;
    }
}

// Imprime posições das primeiras N partículas (para debug)
void printParticles(Particle* particles, int n) {
    for(int i = 0; i < n; i++) {
        std::cout << "Particle " << i << ": "
                  << "(" << particles[i].pos.x << ", "
                  << particles[i].pos.y << ", "
                  << particles[i].pos.z << ")\n";
    }
}
