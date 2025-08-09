import { IsBoolean, IsOptional, IsString, MaxLength, MinLength } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class UpdateTaskDto {

  @ApiProperty({ description: 'Título de la tarea', minLength: 3, maxLength: 255, required: false, example: 'Comprar bebidas' })
  @IsString()
  @MinLength(3,  {message: 'Title must be at least 3 characters long.'})
  @MaxLength(255)
  @IsOptional()
  readonly title?: string;

  @ApiProperty({ description: 'Descripción de la tarea', required: false, example: 'Para la fiesta del viernes' })
  @IsString()
  @IsOptional()
  readonly description?: string;

  @ApiProperty({ description: 'Estado de completado', required: false, example: true })
  @IsBoolean()
  @IsOptional()
  readonly completed?: boolean;
}
