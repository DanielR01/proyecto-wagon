import { Controller, Get, Post, Body, Patch, Param, Delete, UseGuards, Request, Logger } from '@nestjs/common';
  import { TasksService } from './tasks.service';
  import { CreateTaskDto } from './dto/create-task.dto';
  import { UpdateTaskDto } from './dto/update-task.dto';
  import { FirebaseAuthGuard } from 'src/auth/auth.guard';
  import { ApiBearerAuth, ApiOperation, ApiTags, ApiOkResponse, ApiCreatedResponse, ApiUnauthorizedResponse, ApiNotFoundResponse, ApiParam } from '@nestjs/swagger';
  import { Task } from './entities/task.entity';
  
  @ApiBearerAuth()
  @ApiTags('tasks')
  @UseGuards(FirebaseAuthGuard)
  @Controller('tasks')
  export class TasksController {
    private readonly logger = new Logger(TasksController.name);
    constructor(private readonly tasksService: TasksService) {}
  
    @Post() 
    @ApiOperation({ summary: 'Create a new task', description: 'Crea una nueva tarea asociada al usuario autenticado.' })
    @ApiCreatedResponse({ description: 'The task has been successfully created.', type: Task })
    @ApiUnauthorizedResponse({ description: 'Unauthorized.'})
    create(@Body() createTaskDto: CreateTaskDto, @Request() req) {
      const userId = req.user.uid;
      return this.tasksService.create(createTaskDto, userId);
    }
  
    @Get()
    @ApiOperation({ summary: 'List tasks', description: 'Obtiene todas las tareas del usuario autenticado, ordenadas por fecha de creación descendente.' })
    @ApiOkResponse({ description: 'Lista de tareas del usuario', type: Task, isArray: true })
    @ApiUnauthorizedResponse({ description: 'Unauthorized.'})
    findAll(@Request() req) {
      const userId = req.user.uid;
      this.logger.debug(`Finding all tasks for user ${userId}`);
      return this.tasksService.findAllForUser(userId);
    }
  
    @Get(':id')
    @ApiOperation({ summary: 'Get a task by id' })
    @ApiParam({ name: 'id', description: 'UUID de la tarea', example: '6b1b2a57-2a3b-4a2c-b2f1-1a2b3c4d5e6f' })
    @ApiOkResponse({ description: 'Tarea encontrada', type: Task })
    @ApiNotFoundResponse({ description: 'Task not found' })
    @ApiUnauthorizedResponse({ description: 'Unauthorized.'})
    findOne(@Param('id') id: string, @Request() req) {
      const userId = req.user.uid;
      return this.tasksService.findOne(id, userId);
    }
  
    @Patch(':id')
    @ApiOperation({ summary: 'Update a task' })
    @ApiParam({ name: 'id', description: 'UUID de la tarea a actualizar', example: '6b1b2a57-2a3b-4a2c-b2f1-1a2b3c4d5e6f' })
    @ApiOkResponse({ description: 'Tarea actualizada', type: Task })
    @ApiNotFoundResponse({ description: 'Task not found' })
    @ApiUnauthorizedResponse({ description: 'Unauthorized.'})
    update(@Param('id') id: string, @Body() updateTaskDto: UpdateTaskDto, @Request() req) {
      const userId = req.user.uid;
      return this.tasksService.update(id, updateTaskDto, userId);
    }
  
    @Delete(':id')
    @ApiOperation({ summary: 'Delete a task' })
    @ApiParam({ name: 'id', description: 'UUID de la tarea a eliminar', example: '6b1b2a57-2a3b-4a2c-b2f1-1a2b3c4d5e6f' })
    @ApiOkResponse({ description: 'Tarea eliminada' })
    @ApiNotFoundResponse({ description: 'Task not found' })
    @ApiUnauthorizedResponse({ description: 'Unauthorized.'})
    remove(@Param('id') id: string, @Request() req) {
      const userId = req.user.uid;
      return this.tasksService.remove(id, userId);
    }
  }