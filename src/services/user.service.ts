import { userRepository } from '../repositories/user.repository';
import { AppError } from '../utils/AppError';
import { sanitizeUser } from '../utils/sanitizeUser';
import { UpdateUserInput } from '../validations/user.validation';

export const userService = {
  async getAll() {
    const users = await userRepository.findAll();
    return users.map(sanitizeUser);
  },

  async getById(id: string) {
    const user = await userRepository.findById(id);
    if (!user) {
      throw new AppError('User not found', 404);
    }
    return sanitizeUser(user);
  },

  async update(id: string, input: UpdateUserInput) {
    const user = await userRepository.findById(id);
    if (!user) {
      throw new AppError('User not found', 404);
    }

    const updated = await userRepository.update(id, input);
    return sanitizeUser(updated);
  },

  async remove(id: string) {
    const user = await userRepository.findById(id);
    if (!user) {
      throw new AppError('User not found', 404);
    }

    if (user)

    await userRepository.delete(id);
  },

  async setActiveStatus(id: string, isActive: boolean) {
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
