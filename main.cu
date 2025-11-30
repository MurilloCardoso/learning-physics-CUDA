//Bibliotecas
#include "particles.h"
#include <cuda_runtime.h>
#include <iostream>
#include <fstream> 

//funções definidas em functionsToKernel.cu
#include "functionsToKernel.cu"

//parâmetros da simulação
#define NUM_PARTICLES 1024
#define BLOCK_SIZE 256
#define DT 0.01f
#define NUM_STEPS 100

int main() {

    std::ofstream file("particles.csv");
    file << "frame,particle,x,y,z\n";  // cabeçalho do CSV

    Particle* h_particles = new Particle[NUM_PARTICLES];
    initParticles(h_particles, NUM_PARTICLES);

    Particle* d_particles;
    cudaMalloc((void**)&d_particles, NUM_PARTICLES * sizeof(Particle));
    cudaMemcpy(d_particles, h_particles, NUM_PARTICLES * sizeof(Particle), cudaMemcpyHostToDevice);

    int numBlocks = (NUM_PARTICLES + BLOCK_SIZE - 1) / BLOCK_SIZE;

    for(int t = 0; t < NUM_STEPS; t++) {
        computeForces<<<numBlocks, BLOCK_SIZE>>>(d_particles, NUM_PARTICLES, DT);
        cudaDeviceSynchronize();
        updatePositions<<<numBlocks, BLOCK_SIZE>>>(d_particles, DT, NUM_PARTICLES);
        cudaDeviceSynchronize();

        // copiar posições para CPU
        cudaMemcpy(h_particles, d_particles, NUM_PARTICLES * sizeof(Particle), cudaMemcpyDeviceToHost);

        // salvar posições no CSV
        for(int i = 0; i < NUM_PARTICLES; i++) {
            file << t << "," << i << "," 
                << h_particles[i].pos.x << ","
                << h_particles[i].pos.y << ","
                << h_particles[i].pos.z << "\n";
        }
    }
    file.close();

    cudaMemcpy(h_particles, d_particles, NUM_PARTICLES * sizeof(Particle), cudaMemcpyDeviceToHost);

    printParticles(h_particles, 10); // imprime as primeiras 10 partículas

    cudaFree(d_particles);
    delete[] h_particles;

    return 0;
}
