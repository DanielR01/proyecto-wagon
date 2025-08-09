import { IsNotEmpty, IsOptional, IsString, MaxLength, MinLength } from 'class-validator';

export class CreateTaskDto {

  @IsString({ message: 'Title must be a string.' })
  @IsNotEmpty({ message: 'Title cannot be empty.' })
  @MinLength(3, { message: 'Title must be at least 3 characters long.' })
  @MaxLength(255)
  readonly title: string;

  @IsString()
  @IsOptional()
  readonly description?: string;
}