#include "particles.h"
#include <cuda_runtime.h>
#include <iostream>
#include <fstream>  

// Kernel para atualizar posições
__global__ void updatePositions(Particle* particles, float dt, int n) {
    int idx = blockIdx.x * blockDim.x + threadIdx.x;
    if (idx < n) {
        particles[idx].pos.x += particles[idx].vel.x * dt;
        particles[idx].pos.y += particles[idx].vel.y * dt;
        particles[idx].pos.z += particles[idx].vel.z * dt;
    }
}

// Kernel simples de força gravitacional
__global__ void computeForces(Particle* particles, int n, float dt) {
    int idx = blockIdx.x * blockDim.x + threadIdx.x;
    if(idx < n) {
        float3 acc = make_float3(0,0,0);
        for(int j = 0; j < n; j++) {
            if(j != idx) {
                float3 diff;
                diff.x = particles[j].pos.x - particles[idx].pos.x;
                diff.y = particles[j].pos.y - particles[idx].pos.y;
                diff.z = particles[j].pos.z - particles[idx].pos.z;
                float distSqr = diff.x*diff.x + diff.y*diff.y + diff.z*diff.z + 1e-10f;
                float invDist = rsqrtf(distSqr);
                float invDist3 = invDist * invDist * invDist;
                acc.x += diff.x * particles[j].mass * invDist3;
                acc.y += diff.y * particles[j].mass * invDist3;
                acc.z += diff.z * particles[j].mass * invDist3;
            }
        }
        particles[idx].vel.x += acc.x * dt;
        particles[idx].vel.y += acc.y * dt;
        particles[idx].vel.z += acc.z * dt;
    }
}