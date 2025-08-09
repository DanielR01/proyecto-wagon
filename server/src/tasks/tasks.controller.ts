import { Controller, Get, Post, Body, Patch, Param, Delete, UseGuards, Request, Logger } from '@nestjs/common';
  import { TasksService } from './tasks.service';
  import { CreateTaskDto } from './dto/create-task.dto';
  import { UpdateTaskDto } from './dto/update-task.dto';
  import { FirebaseAuthGuard } from 'src/auth/auth.guard';
  
  @UseGuards(FirebaseAuthGuard)
  @Controller('tasks')
  export class TasksController {
    private readonly logger = new Logger(TasksController.name);
    constructor(private readonly tasksService: TasksService) {}
  
    @Post() 
    create(@Body() createTaskDto: CreateTaskDto, @Request() req) {
      const userId = req.user.uid;
      return this.tasksService.create(createTaskDto, userId);
    }
  
    @Get()
    findAll(@Request() req) {
      const userId = req.user.uid;
      this.logger.debug(`Finding all tasks for user ${userId}`);
      return this.tasksService.findAllForUser(userId);
    }
  
    @Get(':id')
    findOne(@Param('id') id: string, @Request() req) {
      const userId = req.user.uid;
      return this.tasksService.findOne(id, userId);
    }
  
    @Patch(':id')
    update(@Param('id') id: string, @Body() updateTaskDto: UpdateTaskDto, @Request() req) {
      const userId = req.user.uid;
      return this.tasksService.update(id, updateTaskDto, userId);
    }
  
    @Delete(':id')
    remove(@Param('id') id: string, @Request() req) {
      const userId = req.user.uid;
      return this.tasksService.remove(id, userId);
    }
  }