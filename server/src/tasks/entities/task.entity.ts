import {
    Entity,
    PrimaryGeneratedColumn,
    Column,
    CreateDateColumn,
    UpdateDateColumn,
  } from 'typeorm';
import { ApiProperty } from '@nestjs/swagger';
  
  @Entity('tasks')
  export class Task {
    @ApiProperty({ description: 'Identificador único de la tarea (UUID)', example: '6b1b2a57-2a3b-4a2c-b2f1-1a2b3c4d5e6f' })
    @PrimaryGeneratedColumn('uuid')
    id: string;
  
    @ApiProperty({ description: 'Título corto de la tarea', maxLength: 255, example: 'Comprar entradas' })
    @Column({ type: 'varchar', length: 255, nullable: false })
    title: string;
  
    @ApiProperty({ description: 'Descripción detallada de la tarea', example: 'Entradas para el concierto del sábado' })
    @Column({ type: 'text', default: '' })
    description: string;
  
    @ApiProperty({ description: 'Indica si la tarea está completada', example: false })
    @Column({ type: 'boolean', default: false })
    completed: boolean;
  
    @ApiProperty({ description: 'Identificador del usuario dueño de la tarea (UID de Firebase)', example: 'uid_firebase_123' })
    @Column({ name: 'user_id' })
    userId: string;
  
    @ApiProperty({ description: 'Fecha de creación', example: '2025-01-01T12:00:00.000Z' })
    @CreateDateColumn({ name: 'created_at', type: 'timestamptz' })
    createdAt: Date;
  
    @ApiProperty({ description: 'Fecha de última actualización', example: '2025-01-02T15:30:00.000Z' })
    @UpdateDateColumn({ name: 'updated_at', type: 'timestamptz' })
    updatedAt: Date;
  }