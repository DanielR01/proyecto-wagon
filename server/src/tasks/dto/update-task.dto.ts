import { IsBoolean, IsOptional, IsString, MaxLength, MinLength } from 'class-validator';

export class UpdateTaskDto {

  @IsString()
  @MinLength(3,  {message: 'Title must be at least 3 characters long.'})
  @MaxLength(255)
  @IsOptional()
  readonly title?: string;

  @IsString()
  @IsOptional()
  readonly description?: string;

  @IsBoolean()
  @IsOptional()
  readonly completed?: boolean;
}
