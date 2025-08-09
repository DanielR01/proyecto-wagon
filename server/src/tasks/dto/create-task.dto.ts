import { IsNotEmpty, IsOptional, IsString, MaxLength, MinLength } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class CreateTaskDto {

  @ApiProperty({ description: 'Título de la tarea', minLength: 3, maxLength: 255, example: 'Reservar restaurante' })
  @IsString({ message: 'Title must be a string.' })
  @IsNotEmpty({ message: 'Title cannot be empty.' })
  @MinLength(3, { message: 'Title must be at least 3 characters long.' })
  @MaxLength(255)
  readonly title: string;

  @ApiProperty({ description: 'Descripción opcional de la tarea', required: false, example: 'Sábado a las 20:00' })
  @IsString()
  @IsOptional()
  readonly description?: string;
}