import bcrypt from 'bcrypt';
import { userRepository } from '../repositories/user.repository';
import { AppError } from '../utils/AppError';
import { sanitizeUser } from '../utils/sanitizeUser';
import { CreateUserInput, UpdateUserInput } from '../validations/user.validation';

const SALT_ROUNDS = 10;

export const userService = {
  async getAll() {
    const users = await userRepository.findAll();
    return users.map(sanitizeUser);
  },

  async create(input: CreateUserInput, createdBy: string) {
    const existing = await userRepository.findByEmail(input.email);
    if (existing) {
      throw new AppError('Email is already in use', 409);
    }

    const hashedPassword = await bcrypt.hash(input.password, SALT_ROUNDS);
    const user = await userRepository.create({
      name: input.name,
      email: input.email,
      password: hashedPassword,
      role: input.role,
      created_by: createdBy,
    });
    return sanitizeUser(user);
  },

  async getById(id: string) {
    const user = await userRepository.findById(id);
    if (!user) {
      throw new AppError('User not found', 404);
    }
    return sanitizeUser(user);
  },

  async update(id: string, input: UpdateUserInput, requestedBy: string) {
    if (id === requestedBy && input.role) {
      throw new AppError('You cannot change your own role', 400);
    }

    const user = await userRepository.findById(id);
    if (!user) {
      throw new AppError('User not found', 404);
    }

    const { password, email, ...rest } = input;
    const data: UpdateUserInput = { ...rest };

    if (email && email !== user.email) {
      const existing = await userRepository.findByEmail(email);

      if (existing) {
        throw new AppError('Email is already in use', 409);
      }
      data.email = email;
    }

    if (password) {
      data.password = await bcrypt.hash(password, SALT_ROUNDS);
    }

    const updated = await userRepository.update(id, data);
    return sanitizeUser(updated);
  },

  async remove(id: string, requestedBy: string) {
    if (id === requestedBy) {
      throw new AppError('You cannot delete your own account', 400);
    }

    const user = await userRepository.findById(id);
    if (!user) {
      throw new AppError('User not found', 404);
    }

    await userRepository.delete(id);
  },

  async setActiveStatus(id: string, isActive: boolean, requestedBy: string) {
    if (id === requestedBy) {
      throw new AppError('You cannot change the active status of your own account', 400);
    }

    const user = await userRepository.findById(id);
    if (!user) {
      throw new AppError('User not found', 404);
    }

    const updated = await userRepository.update(id, {
      is_active: isActive
    });
    return sanitizeUser(updated);
  },
};
